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
