//
//  CFQData.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/4/14.
//

import Foundation

struct CFQData {
    struct Maimai {
        struct UserInfo: Codable {
            var isEmpty: Bool {
                return self.uid == -1 || nickname == "" || self.rating == -1
            }
            
            var uid: Int
            var nickname: String
            var trophy: String
            var rating: Int
            var maxRating: Int
            var star: Int
            var charUrl: String
            var gradeUrl: String
            var playCount: Int
            var stats: String
            var createdAt: String
            var updatedAt: String
            
            static let empty = UserInfo(uid: -1, nickname: "", trophy: "", rating: -1, maxRating: 0, star: 0, charUrl: "", gradeUrl: "", playCount: 0, stats: "", createdAt: "", updatedAt: "")
        }
        
        struct BestScoreEntry: Codable {
            var title: String
            var level: String
            var level_index: Int
            var type: String
            var achievements: Double
            var dxScore: Int
            var rate: String
            var fc: String
            var fs: String
            var ds: Double
            var idx: String
            var createdAt: String
            var updatedAt: String
            
            static let empty = BestScoreEntry(title: "", level: "", level_index: 0, type: "", achievements: 0, dxScore: 0, rate: "", fc: "", fs: "", ds: 0, idx: "", createdAt: "", updatedAt: "")
        }
        
        struct RecentScoreEntry: Codable {
            var timestamp: Int
            var title: String
            var difficulty: String
            var achievements: Double
            var isNewRecord: Int
            var dxScore: Int
            var fc: String
            var fs: String
            var notes_tap: String
            var notes_hold: String
            var notes_slide: String
            var notes_touch: String
            var notes_break: String
            var maxCombo: String
            var maxSync: String
            var matching_1: String
            var matching_2: String
            var matching_3: String
            var createdAt: String
            var updatedAt: String
            
            static let empty = RecentScoreEntry(timestamp: 0, title: "", difficulty: "", achievements: 0, isNewRecord: 0, dxScore: 0, fc: "", fs: "", notes_tap: "", notes_hold: "", notes_slide: "", notes_touch: "", notes_break: "", maxCombo: "", maxSync: "", matching_1: "", matching_2: "", matching_3: "", createdAt: "", updatedAt: "")
        }
        
        struct DeltaEntry: Codable {
            var rating: Int
            var playCount: Int
            var stats: String
            var dxScore: Int
            var achievement: Double
            var syncPoint: Int
            var awakening: Int
            var createdAt: String
            var updatedAt: String
            
            static let empty = DeltaEntry(rating: 0, playCount: 0, stats: "", dxScore: 0, achievement: 0, syncPoint: 0, awakening: 0, createdAt: "", updatedAt: "")
        }
    }
    
    struct Chunithm {
        struct UserInfo: Codable {
            var isEmpty: Bool {
                return self.uid == -1 || nickname == "" || rating == -1
            }
            
            var uid: Int
            var nickname: String
            var trophy: String
            var plate: String
            var dan: Int
            var ribbon: Int
            var rating: Double
            var maxRating: Double
            var overpower_raw: Double
            var overpower_percent: Double
            var lastPlayDate: Int
            var charUrl: String
            var friendCode: String
            var currentGold: Int
            var totalGold: Int
            var playCount: Int
            var createdAt: String
            var updatedAt: String
            
            static let empty = UserInfo(uid: -1, nickname: "", trophy: "", plate: "", dan: 0, ribbon: 0, rating: -1, maxRating: 0, overpower_raw: 0, overpower_percent: 0, lastPlayDate: 0, charUrl: "", friendCode: "", currentGold: 0, totalGold: 0, playCount: 0, createdAt: "", updatedAt: "")
        }
        
        struct BestScoreEntry: Codable {
            var title: String
            var level_index: Int
            var highscore: Int
            var rank_index: Int
            var clear: String
            var full_combo: String
            var full_chain: String
            var idx: String
            var createdAt: String
            var updatedAt: String
            
            static let empty = BestScoreEntry(title: "", level_index: 0, highscore: 0, rank_index: 0, clear: "", full_combo: "", full_chain: "", idx: "", createdAt: "", updatedAt: "")
        }
        
        struct RecentScoreEntry: Codable {
            var playTime: Int
            var idx: String
            var title: String
            var difficulty: String
            var highscore: Int
            var isNewRecord: Int
            var fc: String
            var rank_index: Int
            var judges_critical: Int
            var judges_justice: Int
            var judges_attack: Int
            var judges_miss: Int
            var notes_tap: String
            var notes_hold: String
            var notes_slide: String
            var notes_air: String
            var notes_flick: String
            var createdAt: String
            var updatedAt: String
            
            static let empty = RecentScoreEntry(playTime: 0, idx: "", title: "", difficulty: "", highscore: 0, isNewRecord: 0, fc: "", rank_index: 0, judges_critical: 0, judges_justice: 0, judges_attack: 0, judges_miss: 0, notes_tap: "", notes_hold: "", notes_slide: "", notes_air: "", notes_flick: "", createdAt: "", updatedAt: "")
        }
        
        struct DeltaEntry: Codable {
            var rating: Double
            var overpower_raw: Double
            var overpower_percent: Double
            var currentGold: Int
            var totalGold: Int
            var playCount: Int
            var createdAt: String
            var updatedAt: String
            
            static let empty = DeltaEntry(rating: 0, overpower_raw: 0, overpower_percent: 0, currentGold: 0, totalGold: 0, playCount: 0, createdAt: "", updatedAt: "")
        }
        
        struct Extras: Codable {
            static let empty = Extras(nameplates: [], skills: [], characters: [], trophies: [], mapIcons: [], tickets: [], collections: [])
            
            var nameplates: [Nameplate]
            var skills: [Skill]
            var characters: [Extras.Character]
            var trophies: [Trophy]
            var mapIcons: [MapIcon]
            var tickets: [Ticket]
            var collections: [Extras.Collection]
            
            struct Nameplate: Codable {
                var name: String
                var url: String
                var current: Int
                var createdAt: String
                var updatedAt: String
            }
            
            struct Skill: Codable {
                var name: String
                var icon: String
                var level: Int
                var description: String
                var current: Int
                var createdAt: String
                var updatedAt: String
            }
            
            struct Character: Codable {
                var name: String
                var url: String
                var rank: String
                var exp: Double
                var current: Int
                var createdAt: String
                var updatedAt: String
            }
            
            struct Trophy: Codable {
                var name: String
                var type: String
                var description: String
                var createdAt: String
                var updatedAt: String
            }
            
            struct MapIcon: Codable {
                var name: String
                var url: String
                var current: Int
                var createdAt: String
                var updatedAt: String
            }
            
            struct Ticket: Codable {
                var name: String
                var url: String
                var count: Int
                var description: String
                var createdAt: String
                var updatedAt: String
            }
            
            struct Collection: Codable {
                var charName: String
                var charUrl: String
                var charRank: String
                var charExp: Double
                var charIllust: String
                var ghost: Int
                var silver: Int
                var gold: Int
                var createdAt: String
                var updatedAt: String
            }
        }
        
        struct RatingEntry: Codable {
            var title: String
            var idx: String
            var highscore: Int
            var type: String
        }
    }
}

typealias MaimaiUserInfo = CFQData.Maimai.UserInfo
typealias MaimaiBestScoreEntries = [CFQData.Maimai.BestScoreEntry]
typealias MaimaiRecentScoreEntries = [CFQData.Maimai.RecentScoreEntry]
typealias MaimaiDeltaEntries = [CFQData.Maimai.DeltaEntry]

typealias ChunithmUserInfo = CFQData.Chunithm.UserInfo
typealias ChunithmBestScoreEntries = [CFQData.Chunithm.BestScoreEntry]
typealias ChunithmRecentScoreEntries = [CFQData.Chunithm.RecentScoreEntry]
typealias ChunithmDeltaEntries = [CFQData.Chunithm.DeltaEntry]
typealias ChunithmExtras = CFQData.Chunithm.Extras
typealias ChunithmRatingEntries = [CFQData.Chunithm.RatingEntry]

protocol CFQChunithmCustomConvertable {
    func getGrade(rankIndex: Int) -> String
    func getSong(musicId: Int, songs: Array<ChunithmSongData>) -> ChunithmSongData
}
protocol CFQMaimaiCustomConvertalbe {
    func getRankMultiplier(achievements: Double) -> Double
    func getSong(title: String, songs: Array<MaimaiSongData>) -> MaimaiSongData
}

extension CFQChunithmCustomConvertable {
    func getGrade(rankIndex: Int) -> String {
        switch rankIndex {
        case 0:
            return "D"
        case 1:
            return "C"
        case 2:
            return "B"
        case 3:
            return "BB"
        case 4:
            return "BBB"
        case 5:
            return "A"
        case 6:
            return "AA"
        case 7:
            return "AAA"
        case 8:
            return "S"
        case 9:
            return "S+"
        case 10:
            return "SS"
        case 11:
            return "SS+"
        case 12:
            return "SSS"
        case 13:
            return "SSS+"
        default:
            return "F"
        }
    }
    
    func getSong(musicId: Int, songs: Array<ChunithmSongData>) -> ChunithmSongData {
        let data = songs.first {
            $0.musicId == musicId
        }
        guard let song = data else { return tempSongData }
        return song
    }
}
extension CFQMaimaiCustomConvertalbe {
    func getRankMultiplier(achievements: Double) -> Double {
        switch achievements {
        case ..<50:
            return 4
        case 50..<60:
            return 5
        case 60..<70:
            return 6
        case 70..<75:
            return 7
        case 75..<80:
            return 7.5
        case 80..<90:
            return 8.5
        case 90..<94:
            return 9.5
        case 94..<97:
            return 10.5
        case 97..<98:
            return 12.5
        case 98..<99:
            return 12.7
        case 99..<99.5:
            return 13
        case 99.5..<100:
            return 13.2
        case 100..<100.5:
            return 13.5
        case 100.5...:
            return 14
        default:
            return 0
        }
    }
    
    func getSong(title: String, songs: Array<MaimaiSongData>) -> MaimaiSongData {
        let data = songs.first {
            $0.title == title
        }
        guard let song = data else { return tempMaimaiSong }
        return song
    }
}

extension CFQData.Chunithm.BestScoreEntry: CFQChunithmCustomConvertable {}
extension CFQData.Chunithm.BestScoreEntry {
    func getStatus() -> String {
        if !self.clear.isEmpty {
            if self.full_combo == "fullcombo" {
                return "FC"
            } else if self.full_combo == "alljustice" {
                return "AJ"
            } else {
                return "Clear"
            }
        } else {
            return "Clear"
        }
    }
}

extension CFQData.Chunithm.RecentScoreEntry: CFQChunithmCustomConvertable {}

extension CFQData.Chunithm.RatingEntry {
    
}

extension CFQData.Maimai.BestScoreEntry: CFQMaimaiCustomConvertalbe {}
extension CFQData.Maimai.BestScoreEntry {
    func getStatus() -> String {
        self.fc.isEmpty ? "" : self.fc.uppercased()
    }
    
    func getSyncStatus() -> String {
        self.fs.isEmpty ? "" : self.fs.uppercased()
    }
    
    func rating(songs: Array<MaimaiSongData>) -> Int {
        let song = songs.first {
            $0.title == self.title
        }
        guard let thisSong = song else { return -1 }
        guard self.level_index < 5 else { return -1 }
        
        let constant = thisSong.constant[self.level_index]
        let score = min(100.5, self.achievements)
        let rankMultiplier = getRankMultiplier(achievements: self.achievements)
        return Int((constant * score * rankMultiplier).rounded(.down))
    }
}

extension CFQData.Maimai.RecentScoreEntry: CFQMaimaiCustomConvertalbe {}
extension CFQData.Maimai.RecentScoreEntry {
    func rating(songs: Array<MaimaiSongData>) -> Int {
        let song = songs.first {
            $0.title == self.title
        }
        var level_index: Int {
            switch self.difficulty.lowercased() {
            case "basic":
                return 0
            case "advanced":
                return 1
            case "expert":
                return 2
            case "master":
                return 3
            case "re:master":
                return 4
            default:
                return 0
            }
        }
        guard let thisSong = song else { return -1 }
        guard level_index < 5 else { return -1 }
        
        let constant = thisSong.constant[level_index]
        let score = min(100.5, self.achievements)
        let rankMultiplier = getRankMultiplier(achievements: self.achievements)
        return Int((constant * score * rankMultiplier).rounded(.down))
    }
}
