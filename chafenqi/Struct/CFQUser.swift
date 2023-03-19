//
//  CFQUserData.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/3/18.
//

import Foundation
import SwiftUI

class CFQUser: ObservableObject {
    @Published var didLogin = false
    
    @Published var token = ""
    
    @AppStorage("settingsCurrentMode") var currentMode = 0
    @AppStorage("settingsRecentLogEntryCount") var entryCount = "30"
    
    var username = ""
    var nickname = ""
    var displayName = ""
    
    var maimai: Maimai? = Maimai()
    var chunithm: Chunithm? = Chunithm()
    
    var data = CFQPersistentData()
    
    var shouldReload = true
    
    let dateFormat = "MM-dd HH:mm"
    
    struct Maimai: Codable {
        var profile: MaimaiPlayerProfile = MaimaiPlayerProfile.shared
        var record: MaimaiPlayerRecord = MaimaiPlayerRecord.shared
        var recent: Array<MaimaiRecentRecord> = []
        
        var custom: Custom = Custom()
        
        struct Custom: Codable {
            var pastRating = 0
            var currentRating = 0
            var rawRating = 0
            var totalCharts = 0
            var totalPlayed = 0
            var avgAchievement = 0.0
            var nationalRanking = 0
            
            var lastUpdateDate = ""
        }
    }
    
    struct Chunithm: Codable {
        var profile: ChunithmUserData = ChunithmUserData.shared
        var rating: ChunithmUserScoreData = ChunithmUserScoreData.shared
        var recent: Array<ChunithmRecentRecord> = []
        var custom: Custom = Custom()
        
        struct Custom: Codable {
            var overpower = 0.0
            var maxRating = 0.0
            
            var lastUpdateDate = ""
        }
    }
    
    private func calculateMaimaiData() {
        let songlist = self.data.maimai.songlist
        let records = self.maimai!.record.records
        let ranking = self.data.maimai.ranking
        
        let pastSlice = self.maimai!.record.getPastSlice(songData: songlist)
        let currentSlice = self.maimai!.record.getCurrentSlice(songData: songlist)
        
        self.maimai!.custom.pastRating = pastSlice.reduce(0) { $0 + $1.rating }
        self.maimai!.custom.currentRating = currentSlice.reduce(0) { $0 + $1.rating }
        self.maimai!.custom.rawRating = self.maimai!.custom.pastRating + self.maimai!.custom.currentRating
        
        self.maimai!.custom.totalCharts = songlist.reduce(0) {
            $0 + $1.charts.count
        }
        self.maimai!.custom.totalPlayed = records.count
        
        self.maimai!.custom.avgAchievement = records.reduce(0.0) {
            $0 + $1.achievements / Double(records.count)
        }
        
        let sortedRanking = ranking.sorted {
            $0.rating > $1.rating
        }
        self.maimai!.custom.nationalRanking = (sortedRanking.firstIndex(where: {
            $0.username == self.maimai!.profile.username
        }) ?? -1) + 1
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
        let lastDate = Date(timeIntervalSince1970: TimeInterval(self.maimai!.recent.sorted {
            $0.timestamp > $1.timestamp
        }[0].timestamp))
        self.maimai!.custom.lastUpdateDate = formatter.string(from: lastDate)
    }
    
    private func calculateChunithmData() {
        self.chunithm!.custom.overpower = self.chunithm!.profile.getOverpower()
        self.chunithm!.custom.maxRating = self.chunithm!.profile.getMaximumRating()
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
        let lastDate = Date(timeIntervalSince1970: TimeInterval(self.chunithm!.recent.sorted {
            $0.timestamp > $1.timestamp
        }[0].timestamp))
        self.chunithm!.custom.lastUpdateDate = formatter.string(from: lastDate)
    }
    
    func refresh() async {
        shouldReload = true
        await self.loadFromToken(token: token, data: data)
    }
    
    func loadFromToken(token: String, data: CFQPersistentData) async {
        guard shouldReload else { return }
        
        self.token = token
        self.data = data
        
        do {
            let maimaiProfile = try await JSONDecoder().decode(MaimaiPlayerProfile.self, from: MaimaiDataGrabber.getPlayerProfile(token: token))
            let maimaiRecord = try await JSONDecoder().decode(MaimaiPlayerRecord.self, from: MaimaiDataGrabber.getPlayerRecord(token: token))
            let maimaiRecent = try await JSONDecoder().decode(Array<MaimaiRecentRecord>.self, from: MaimaiDataGrabber.getRecentData(username: maimaiProfile.username, limit: Int(entryCount) ?? 30))
            
            self.maimai = Maimai(profile: maimaiProfile, record: maimaiRecord, recent: maimaiRecent)
            calculateMaimaiData()
        } catch {
            print(error)
            self.maimai = nil
        }
        
        do {
            let chunithmProfile = try await JSONDecoder().decode(ChunithmUserData.self, from: ChunithmDataGrabber.getUserRecord(token: token))
            let chunithmRecent = try await JSONDecoder().decode(Array<ChunithmRecentRecord>.self, from: ChunithmDataGrabber.getRecentData(username: chunithmProfile.username, limit: Int(entryCount) ?? 30))
            let chunithmUserScore = try await JSONDecoder().decode(ChunithmUserScoreData.self, from: ChunithmDataGrabber.getUserScoreData(username: chunithmProfile.username))
            
            self.chunithm = Chunithm(profile: chunithmProfile, rating: chunithmUserScore, recent: chunithmRecent)
            calculateChunithmData()
        } catch {
            print(error)
            self.chunithm = nil
        }
        
        self.username = self.maimai?.profile.username ?? self.chunithm?.profile.username ?? ""
        self.nickname = self.maimai?.profile.nickname ?? self.chunithm?.profile.username ?? ""
        
        self.displayName = self.nickname.isEmpty ? self.username : self.nickname
        
        shouldReload = false
    }
}

extension Int {
    mutating func flip() {
        self = 1 - self
    }
}

extension Double {
    func cut(remainingDigits: Int) -> Double {
        return floor(self * pow(10, Double(remainingDigits))) / pow(10, Double(remainingDigits))
    }
}
