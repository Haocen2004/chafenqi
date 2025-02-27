//
//  CFQSonglist.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/3/18.
//

import Foundation
import SwiftUI

class CFQPersistentData: ObservableObject {
    @Published var chunithm: Chunithm = Chunithm()
    @Published var maimai: Maimai = Maimai()
    
    var shouldReload = true
    
    struct Chunithm {
        @AppStorage("loadedChunithmSongs") var loadedSongs: Data = Data()
        @AppStorage("loadedChunithmMusics") var loadedMusics: Data = Data()
        @AppStorage("chartIDMap") var mapData = Data()
        
        var songs: Array<ChunithmSongData> = []
        var musics: Array<ChunithmMusicData> = []
        
        static func hasCache() -> Bool {
            @AppStorage("loadedChunithmSongs") var loadedSongs: Data = Data()
            @AppStorage("loadedChunithmMusics") var loadedMusics: Data = Data()
            return !loadedSongs.isEmpty && !loadedMusics.isEmpty
        }
    }
    
    struct Maimai {
        @AppStorage("loadedMaimaiChartStats") var loadedStats: Data = Data()
        @AppStorage("loadedMaimaiSongs") var loadedSongs: Data = Data()
        @AppStorage("loadedMaimaiRanking") var loadedRanking: Data = Data()
        
        var songlist: Array<MaimaiSongData> = []
        var chartStats: MaimaiChartStatWrapper = MaimaiChartStatWrapper(charts: [:])
        var ranking: Array<MaimaiPlayerRating> = []
        
        static func hasCache() -> Bool {
            @AppStorage("loadedMaimaiChartStats") var loadedStats: Data = Data()
            @AppStorage("loadedMaimaiSongs") var loadedSongs: Data = Data()
            @AppStorage("loadedMaimaiRanking") var loadedRanking: Data = Data()
            return !loadedStats.isEmpty && !loadedSongs.isEmpty && !loadedRanking.isEmpty
        }
    }
    
    private func loadChunithm() async throws {
        self.chunithm.songs = try JSONDecoder().decode(Array<ChunithmSongData>.self, from: self.chunithm.loadedSongs)
        self.chunithm.musics = try JSONDecoder().decode(Array<ChunithmMusicData>.self, from: self.chunithm.loadedMusics)
        
        let path = Bundle.main.url(forResource: "IdMap", withExtension: "json")
        self.chunithm.mapData = try Data(contentsOf: path!)
    }
    
    private func reloadChunithm() async throws {
        try await self.chunithm.loadedSongs = JSONEncoder().encode(ChunithmDataGrabber.getSongDataSetFromServer())
        try await self.chunithm.loadedMusics = CFQChunithmServer.fetchMusicData()
        
        self.chunithm.songs = try JSONDecoder().decode(Array<ChunithmSongData>.self, from: self.chunithm.loadedSongs)
        self.chunithm.musics = try JSONDecoder().decode(Array<ChunithmMusicData>.self, from: self.chunithm.loadedMusics)
        
        var decoded = try JSONDecoder().decode(Array<ChunithmSongData>.self, from: self.chunithm.loadedSongs)
        decoded = decoded.filter { $0.constant != [0.0, 0.0, 0.0, 0.0, 0.0, 0.0] && $0.constant != [0.0] }
        
        let dlcPath = Bundle.main.url(forResource: "dlc", withExtension: "json")
        let dlc = try JSONDecoder().decode(Array<ChunithmSongData>.self, from: Data(contentsOf: dlcPath!))
        decoded.append(contentsOf: dlc)
        
        self.chunithm.loadedSongs = try JSONEncoder().encode(decoded)
        self.chunithm.songs = decoded
        
        let path = Bundle.main.url(forResource: "IdMap", withExtension: "json")
        self.chunithm.mapData = try Data(contentsOf: path!)
    }
    
    private func loadMaimai() async throws {
        self.maimai.songlist = try JSONDecoder().decode(Array<MaimaiSongData>.self, from: self.maimai.loadedSongs)
        self.maimai.chartStats = try JSONDecoder().decode(MaimaiChartStatWrapper.self, from: self.maimai.loadedStats)
        self.maimai.ranking = try JSONDecoder().decode(Array<MaimaiPlayerRating>.self, from: self.maimai.loadedRanking)
    }
    
    private func reloadMaimai() async throws {
        self.maimai.loadedSongs = try await MaimaiDataGrabber.getMusicData()
        self.maimai.loadedStats = try await MaimaiDataGrabber.getChartStat()
        self.maimai.loadedRanking = try await MaimaiDataGrabber.getRatingRanking()
        
        self.maimai.songlist = try JSONDecoder().decode(Array<MaimaiSongData>.self, from: self.maimai.loadedSongs)
        self.maimai.chartStats = try JSONDecoder().decode(MaimaiChartStatWrapper.self, from: self.maimai.loadedStats)
        self.maimai.ranking = try JSONDecoder().decode(Array<MaimaiPlayerRating>.self, from: self.maimai.loadedRanking)
    }
    
    func update() async throws {
        try await reloadMaimai()
        try await reloadChunithm()
        
        shouldReload = false
    }
    
    func loadFromCache() async throws {
        try await loadMaimai()
        try await loadChunithm()
        
        shouldReload = false
    }
    
    func refresh() async throws {
        shouldReload = true
        try await update()
    }
    
    static func loadFromCacheOrRefresh() async throws -> CFQPersistentData {
        let data = CFQPersistentData()
        if (Maimai.hasCache() && Chunithm.hasCache()) {
            try await data.loadFromCache()
            data.shouldReload = false
            print("[CFQPersistentData] Persistent data cache loaded.")
            return data
        } else {
            try await data.update()
            print("[CFQPersistentData] Persistent data downloaded.")
            return data
        }
    }
    
    static func forceRefresh() async throws -> CFQPersistentData {
        let data = CFQPersistentData()
        try await data.update()
        print("[CFQPersistentData] Persistent data downloaded.")
        return data
    }
}
