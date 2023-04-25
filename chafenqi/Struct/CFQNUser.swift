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
    
    @AppStorage("settingsRecentLogEntryCount") var entryCount = "30"
    @AppStorage("firstTimeLaunch") var firstTime = true
    @AppStorage("proxyDidInstallProfile") var installed = false
    
    var username = ""
    var fishUsername = ""
    @AppStorage("JWT") var jwtToken = ""
    
    var isPremium = false
    
    var maimai = Maimai()
    var chunithm = Chunithm()
    var persistent = CFQPersistentData()
    
    class Maimai: Codable {
        class Rating: Codable {
            var past: Int
            var current: Int
            
            var pastSlice: [CFQData.Maimai.BestScoreEntry]
            var currentSlice: [CFQData.Maimai.BestScoreEntry]
        }
        
        var isEmpty: Bool {
            return self.info.isEmpty || self.bestScore.isEmpty || self.recentScore.isEmpty
        }
        
        var info: MaimaiUserInfo
        var bestScore: MaimaiBestScoreEntries
        var recentScore: MaimaiRecentScoreEntries
        var delta: MaimaiDeltaEntries
        
        var shim: CFQDataShim.Maimai
        
        init(jwtToken: String, data: CFQPersistentData.Maimai) async throws {
            self.info = try await MaimaiServer.fetchUserInfo(token: jwtToken)
            self.bestScore = try await MaimaiServer.fetchUserBest(token: jwtToken)
            self.recentScore = try await MaimaiServer.fetchUserRecent(token: jwtToken)
            self.delta = try await MaimaiServer.fetchUserDelta(token: jwtToken)
            self.shim = .init(songs: data.songs, best: self.bestScore)
        }
        
        init() {
            self.info = .empty
            self.bestScore = []
            self.recentScore = []
            self.delta = []
            self.shim = .init()
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
        var rating: ChunithmRatingEntries
        
        var fishUserInfo: ChunithmUserData // From Diving-Fish
        
        init(jwtToken: String) async throws {
            self.info = try await ChunithmServer.fetchUserInfo(token: jwtToken)
            self.bestScore = try await ChunithmServer.fetchUserBest(token: jwtToken)
            self.recentScore = try await ChunithmServer.fetchUserRecent(token: jwtToken)
            self.delta = try await ChunithmServer.fetchUserDelta(token: jwtToken)
            self.extras = try await ChunithmServer.fetchUserExtras(token: jwtToken)
            self.rating = try await ChunithmServer.fetchUserRating(token: jwtToken)
            self.fishUserInfo = .shared
        }
        
        init() {
            self.info = .empty
            self.bestScore = []
            self.recentScore = []
            self.delta = []
            self.extras = .empty
            self.rating = []
            self.fishUserInfo = .shared
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
                self.maimai = try await Maimai(jwtToken: self.jwtToken, data: self.persistent.maimai)
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
        
        // Load shim
        if (!self.maimai.isEmpty) {
            self.maimai.shim = .init(songs: self.persistent.maimai.songs, best: self.maimai.bestScore)
        }
    }
    
    init() {
        
    }
}

enum CFQNUserError: Error {
    case SavingError(cause: String, from: String)
    case LoadingError(cause: String, from: String)
}

extension MaimaiRecentScoreEntries {
    func getLatestNewRecord() -> (Int?, CFQData.Maimai.RecentScoreEntry?) {
        let new = self.filter {
            $0.isNewRecord == 1
        }.sorted {
            $0.timestamp > $1.timestamp
        }.first
        return (self.firstIndex {
            $0.timestamp == new?.timestamp
        }, new)
    }
    
    func getLatestHighscore() -> (Int?, CFQData.Maimai.RecentScoreEntry?) {
        let high = self.filter {
            $0.achievements >= 100.0
        }.sorted {
            $0.achievements > $1.achievements
        }.first
        return (self.firstIndex {
            $0.timestamp == high?.timestamp
        }, high)
    }
}

extension ChunithmRecentScoreEntries {
    func getLatestNewRecord() -> (Int?, CFQData.Chunithm.RecentScoreEntry?) {
        let new = self.filter {
            $0.isNewRecord == 1
        }.sorted {
            $0.playTime > $1.playTime
        }.first
        return (self.firstIndex {
            $0.playTime == new?.playTime
        }, new)
    }
    
    func getLatestHighscore() -> (Int?, CFQData.Chunithm.RecentScoreEntry?) {
        let high = self.filter {
            $0.highscore > 1000000
        }.sorted {
            $0.highscore > $1.highscore
        }.first
        return (self.firstIndex {
            $0.playTime == high?.playTime
        }, high)
    }
}
