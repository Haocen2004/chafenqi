//
//  CFQServer.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/4/14.
//

import Foundation
import Crypto
import AlertToast

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
            } catch CFQServerError.RequestError {
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
            } catch CFQServerError.RequestError {
                throw CFQServerError.RequestError
            }
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
        static func fetchUserInfo(token: String) async throws -> MaimaiUserInfo {
            return try await fetchDataByCategory(MaimaiUserInfo.self, game: "maimai", category: "info", token: token) ?? .empty
        }
        
        static func fetchUserBest(token: String) async throws -> MaimaiBestScoreEntries {
            try await fetchDataByCategory(MaimaiBestScoreEntries.self, game: "maimai", category: "best", token: token) ?? []
        }
        
        static func fetchUserRecent(token: String) async throws -> MaimaiRecentScoreEntries {
            try await fetchDataByCategory(MaimaiRecentScoreEntries.self, game: "maimai", category: "recent", token: token) ?? []
        }
        
        static func fetchUserDelta(token: String) async throws -> MaimaiDeltaEntries {
            do {
                return try await fetchDataByCategory(MaimaiDeltaEntries.self, game: "maimai", category: "delta", token: token) ?? []
            } catch CFQServerError.UserNotPremiumError {
                return []
            }
        }
    }
    
    struct Chunithm {
        static func fetchUserInfo(token: String) async throws -> ChunithmUserInfo {
            try await fetchDataByCategory(ChunithmUserInfo.self, game: "chunithm", category: "info", token: token) ?? .empty
        }
        
        static func fetchUserBest(token: String) async throws -> ChunithmBestScoreEntries {
            try await fetchDataByCategory(ChunithmBestScoreEntries.self, game: "chunithm", category: "best", token: token) ?? []
        }
        
        static func fetchUserRecent(token: String) async throws -> ChunithmRecentScoreEntries {
            try await fetchDataByCategory(ChunithmRecentScoreEntries.self, game: "chunithm", category: "recent", token: token) ?? []
        }
        
        static func fetchUserDelta(token: String) async throws -> ChunithmDeltaEntries {
            do {
                return try await fetchDataByCategory(ChunithmDeltaEntries.self, game: "chunithm", category: "delta", token: token) ?? []
            } catch CFQServerError.UserNotPremiumError {
                return []
            }
        }
        
        static func fetchUserExtras(token: String) async throws -> ChunithmExtras {
            do {
                return try await fetchDataByCategory(ChunithmExtras.self, game: "chunithm", category: "extras", token: token) ?? .empty
            } catch CFQServerError.UserNotPremiumError {
                return ChunithmExtras.empty
            }
        }
        
        static func fetchUserRating(token: String) async throws -> ChunithmRatingEntries {
            return try await fetchDataByCategory(ChunithmRatingEntries.self, game: "chunithm", category: "rating", token: token) ?? []
        }
    }
    
    static private func fetchDataByCategory<T>(_ t: T.Type, game: String, category: String, token: String) async throws -> T? where T : Decodable {
        do {
            let (data, response) = try await communicateWithPayload(path: "api/\(game)/\(category)", method: "GET", token: token)
            if (response.statusCode() != 200) {
                print(response.statusCode())
                try throwErrorByMessageData(errMessageData: data)
            }
            return try JSONDecoder().decode(T.self, from: data)
        } catch DecodingError.dataCorrupted(_) {
            return nil
        } catch is DecodingError {
            throw CFQServerError.ParsingError
        } catch CFQServerError.EmptyRecordError {
            return nil
        } catch {
            throw error
        }
    }
    
    static private func throwErrorByMessageData(errMessageData: Data) throws {
        guard let errMessage = String(data: errMessageData, encoding: .utf8) else { throw CFQServerError.ParsingError }
        print(errMessage)
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
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if (!token.isEmpty) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        if (!payload.isEmpty) {
            request.setValue("\(payload.count)", forHTTPHeaderField: "Content-Length")
            request.httpBody = payload
        }
        request.httpMethod = method
        print(method, request.url!)
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

extension CFQServerError: CustomStringConvertible {
    public var description: String {
        switch (self) {
        case .ParsingError:
            return "数据解析失败"
        case .RequestError:
            return "无法连接至服务器"
        case .CredentialsNotMatchError:
            return "用户名或密码错误"
        case .UserNotFoundError:
            return "用户不存在"
        case .TokenInvalidError:
            return "Token无效"
        case .EmptyRecordError:
            return "无用户数据"
        case .UserNotPremiumError:
            return "非赞助用户"
        case .ServerError(let errMessage):
            return "服务器发生错误: \(errMessage)"
        }
    }
}

extension CFQServerError {
    func alertToast() -> AlertToast {
        return AlertToast(displayMode: .hud, type: .error(.red), title: "发生错误", subTitle: self.description)
    }
}

typealias AuthServer = CFQServer.Auth
typealias TokenServer = CFQServer.Fish
typealias MaimaiServer = CFQServer.Maimai
typealias ChunithmServer = CFQServer.Chunithm
