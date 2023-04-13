//
//  Updater.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/4/14.
//

import Foundation
import Crypto

struct CFQServer {
    struct Auth {
        static func auth(username: String, plainPassword: String) async throws -> String {
            let body = ["username": username, "password": plainPassword.sha256String()]
            
            do {
                let (data, response) = try await communicateWithPayload(path: "api/auth", method: "POST", payload: JSONSerialization.data(withJSONObject: body))
                let resString = String(data: data, encoding: .utf8)
                if (response.statusCode() != 200) {
                    try throwErrorByMessageData(errMessageData: data)
                }
                guard let token = resString else { throw CFQServerError.ParsingError }
                return token
            } catch {
                throw CFQServerError.RequestError
            }
        }
        
        static func register(username: String, plainPassword: String) async throws -> Bool {
            do {
                guard try await checkUsernameAvailability(username: username) else { return false }
            } catch {
                throw CFQServerError.RequestError
            }
            
            let body = ["username": username, "password": plainPassword.sha256String()]
            do {
                let (_, response) = try await communicateWithPayload(path: "api/register", method: "POST", payload: JSONSerialization.data(withJSONObject: body))
                return response.statusCode() == 200
            } catch {
                
            }
            return false
        }
        
        static private func checkUsernameAvailability(username: String) async throws -> Bool {
            let body = ["username": username]
            do {
                let (_, response) = try await communicateWithPayload(path: "api/checkUsername", method: "POST", payload: JSONSerialization.data(withJSONObject: body))
                if (response.statusCode() != 200) {
                    // Not Available
                    return false
                }
                return true
            } catch {
                throw CFQServerError.RequestError
            }
        }
    }
    
    struct Fish {
        static func uploadToken(authToken: String, fishToken: String) async throws {
            let body = ["token": fishToken]
            let (_, response) = try await communicateWithPayload(path: "fish/upload_token", method: "POST", payload: JSONSerialization.data(withJSONObject: body), token: authToken)
            if (response.statusCode() != 200) {
                throw CFQServerError.RequestError
            }
        }
    }
    
    struct Maimai {
        static func fetchUserInfo(token: String) async throws -> CFQData.Maimai.UserInfo {
            return try await fetchDataByCategory(CFQData.Maimai.UserInfo.self, game: "maimai", category: "info", token: token)
        }
        
        static func fetchUserBest(token: String) async throws -> [CFQData.Maimai.BestScoreEntry] {
            try await fetchDataByCategory(Array<CFQData.Maimai.BestScoreEntry>.self, game: "maimai", category: "best", token: token)
        }
        
        static func fetchUserRecent(token: String) async throws -> [CFQData.Maimai.RecentScoreEntry] {
            try await fetchDataByCategory(Array<CFQData.Maimai.RecentScoreEntry>.self, game: "maimai", category: "recent", token: token)
        }
        
        static func fetchUserDelta(token: String) async throws -> [CFQData.Maimai.DeltaEntry] {
            try await fetchDataByCategory(Array<CFQData.Maimai.DeltaEntry>.self, game: "maimai", category: "delta", token: token)
        }
    }
    
    struct Chunithm {
        static func fetchUserInfo(token: String) async throws -> CFQData.Chunithm.UserInfo {
            try await fetchDataByCategory(CFQData.Chunithm.UserInfo.self, game: "chunithm", category: "info", token: token)
        }
        
        static func fetchUserBest(token: String) async throws -> [CFQData.Chunithm.BestScoreEntry] {
            try await fetchDataByCategory(Array<CFQData.Chunithm.BestScoreEntry>.self, game: "chunithm", category: "best", token: token)
        }
        
        static func fetchUserRecent(token: String) async throws -> [CFQData.Chunithm.RecentScoreEntry] {
            try await fetchDataByCategory(Array<CFQData.Chunithm.RecentScoreEntry>.self, game: "chunithm", category: "recent", token: token)
        }
        
        static func fetchUserDelta(token: String) async throws -> [CFQData.Chunithm.DeltaEntry] {
            try await fetchDataByCategory(Array<CFQData.Chunithm.DeltaEntry>.self, game: "chunithm", category: "delta", token: token)
        }
        
        static func fetchUserExtras(token: String) async throws -> CFQData.Chunithm.Extras {
            try await fetchDataByCategory(CFQData.Chunithm.Extras.self, game: "chunithm", category: "extras", token: token)
        }
    }
    
    static private func fetchDataByCategory<T>(_ t: T.Type, game: String, category: String, token: String) async throws -> T where T : Decodable {
        do {
            let (data, response) = try await communicateWithPayload(path: "api/\(game)/\(category)", method: "GET", token: token)
            if (response.statusCode() != 200) {
                try throwErrorByMessageData(errMessageData: data)
            }
            return try JSONDecoder().decode(T.self, from: data)
        } catch is DecodingError {
            throw CFQServerError.ParsingError
        } catch {
            throw CFQServerError.RequestError
        }
    }
    
    static private func throwErrorByMessageData(errMessageData: Data) throws {
        guard let errMessage = String(data: errMessageData, encoding: .utf8) else { throw CFQServerError.ParsingError }
        switch errMessage {
        case "INVALID":
            throw CFQServerError.TokenInvalidError
        case "NOT FOUND":
            throw CFQServerError.UserNotFoundError
        case "EMPTY":
            throw CFQServerError.EmptyRecordError
        case "MISMATCH":
            throw CFQServerError.CredentialsNotMatchError
        case "NOT PREMIUM":
            throw CFQServerError.UserNotPremiumError
        default:
            throw CFQServerError.ServerError(errMessage: errMessage)
        }
    }
    
    static private func communicateWithPayload(path: String, method: String, payload: Data = Data(), token: String = "", queryItems: [URLQueryItem] = []) async throws -> (Data, URLResponse) {
        let session = URLSession.shared
        var comp = URLComponents(string: "http://43.139.107.206:8083/\(path)")!
        if (!queryItems.isEmpty) {
            comp.queryItems = queryItems
        }
        var request = URLRequest(url: comp.url!)
        
        if (!token.isEmpty) {
            request.setValue("Authorization", forHTTPHeaderField: "Bearer \(token)")
        }
        if (!payload.isEmpty) {
            request.httpBody = payload
        }
        request.httpMethod = method
        
        return try await session.data(for: request)
    }
}

extension String {
    func sha256String() -> String {
        let digest = SHA256.hash(data: self.data(using: .utf8)!)
        return digest.compactMap {
            String(format: "%02x", $0)
        }.joined()
    }
}

enum CFQServerError: Error {
    case ParsingError
    case RequestError
    case CredentialsNotMatchError
    case UserNotFoundError
    case TokenInvalidError
    case EmptyRecordError
    case UserNotPremiumError
    case ServerError(errMessage: String)
}
