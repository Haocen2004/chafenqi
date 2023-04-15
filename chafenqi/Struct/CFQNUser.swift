//
//  CFQNUser.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/4/15.
//

import Foundation
import SwiftUI

class CFQNUser: ObservableObject {
    @Published var didLogin = false
    
    @AppStorage("MaimaiCache") var maimaiCache = Data()
    @AppStorage("ChunithmCache") var chunithmCache = Data()
    
    @AppStorage("settingsChunithmCoverSource") var chunithmCoverSource = 1
    @AppStorage("settingsMaimaiCoverSource") var maimaiCoverSource = 0
    
    @AppStorage("userCurrentMode") var currentMode = 0
    
    var username = ""
    @AppStorage("JWT") var jwtToken = ""
    
    var isPremium = false
    
    var maimai = Maimai()
    var chunithm = Chunithm()
    var persistent = CFQPersistentData()
    
    class Maimai: Codable {
        var isEmpty: Bool {
            return self.info.isEmpty || self.bestScore.isEmpty || self.recentScore.isEmpty
        }
        
        var info: MaimaiUserInfo
        var bestScore: MaimaiBestScoreEntries
        var recentScore: MaimaiRecentScoreEntries
        var delta: MaimaiDeltaEntries
        
        init(jwtToken: String) async throws {
            self.info = try await MaimaiServer.fetchUserInfo(token: jwtToken)
            self.bestScore = try await MaimaiServer.fetchUserBest(token: jwtToken)
            self.recentScore = try await MaimaiServer.fetchUserRecent(token: jwtToken)
            self.delta = try await MaimaiServer.fetchUserDelta(token: jwtToken)
        }
        
        init() {
            self.info = .empty
            self.bestScore = []
            self.recentScore = []
            self.delta = []
        }
    }
    
    class Chunithm: Codable {
        var isEmpty: Bool {
            return self.info.isEmpty || self.bestScore.isEmpty || self.recentScore.isEmpty
        }
        
        var info: ChunithmUserInfo
        var bestScore: ChunithmBestScoreEntries
        var recentScore: ChunithmRecentScoreEntries
        var delta: ChunithmDeltaEntries
        var extras: ChunithmExtras
        
        init(jwtToken: String) async throws {
            self.info = try await ChunithmServer.fetchUserInfo(token: jwtToken)
            self.bestScore = try await ChunithmServer.fetchUserBest(token: jwtToken)
            self.recentScore = try await ChunithmServer.fetchUserRecent(token: jwtToken)
            self.delta = try await ChunithmServer.fetchUserDelta(token: jwtToken)
            self.extras = try await ChunithmServer.fetchUserExtras(token: jwtToken)
        }
        
        init() {
            self.info = .empty
            self.bestScore = []
            self.recentScore = []
            self.delta = []
            self.extras = .empty
        }
    }
    
    func saveToCache() async throws {
        do {
            maimaiCache = try JSONEncoder().encode(self.maimai)
            chunithmCache = try JSONEncoder().encode(self.chunithm)
        } catch {
            throw CFQNUserError.SavingError(cause: String(describing: error), from: "Saving user data cache")
        }
    }
    
    func load(username: String, forceReload: Bool = false) async throws {
        if (forceReload) {
            self.persistent = try await .forceRefresh()
        } else {
            self.persistent = try await .loadFromCacheOrRefresh()
        }
        
        do {
            if (!jwtToken.isEmpty) {
                // Load from server
                self.maimai = try await Maimai(jwtToken: self.jwtToken)
                self.chunithm = try await Chunithm(jwtToken: self.jwtToken)
            } else {
                // Load from cache
                self.maimai = try JSONDecoder().decode(Maimai.self, from: maimaiCache)
                self.chunithm = try JSONDecoder().decode(Chunithm.self, from: chunithmCache)
            }
        } catch {
            throw CFQNUserError.LoadingError(cause: String(describing: error), from: "Loading user data from server")
        }
        
        self.username = username
    }
    
    init() {
        
    }
}

enum CFQNUserError: Error {
    case SavingError(cause: String, from: String)
    case LoadingError(cause: String, from: String)
}
