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
        
        struct ExtrasEntry: Codable {
            var nameplates: [Nameplate]
            var skills: [Skill]
            var characters: [ExtrasEntry.Character]
            var trophies: [Trophy]
            var mapIcons: [MapIcon]
            var tickets: [Ticket]
            var collections: [ExtrasEntry.Collection]
            
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
