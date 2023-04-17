//
//  CFQDataShim.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/4/17.
//

import Foundation

class CFQDataShim: Codable {
    var maimai: Maimai
    
    class Maimai: Codable {
        // musicId to title map
        var idMap: Dictionary<String, MaimaiSongData> = [:]
        var pastSlice: MaimaiBestScoreEntries = []
        var currentSlice: MaimaiBestScoreEntries = []
        
        var rawRating = 0
        var pastRating = 0
        var currentRating = 0
        
        init(songs: Array<MaimaiSongData>, best: MaimaiBestScoreEntries) {
            for entry in best {
                let data = songs.first {
                    $0.title == entry.title
                }
                guard let song = data else { continue }
                self.idMap[song.musicId] = song
            }
            
            self.pastSlice = best.filter {
                let data = self.idMap[$0.title]
                guard let song = data else { return false }
                return !song.basicInfo.isNew
            }
            
            self.currentSlice = best.filter {
                let data = self.idMap[$0.title]
                guard let song = data else { return false }
                return song.basicInfo.isNew
            }
            
            self.pastRating = getRatingFromSlice(songs: songs, slice: pastSlice)
            self.currentRating = getRatingFromSlice(songs: songs, slice: currentSlice)
            self.rawRating = self.pastRating + self.currentRating
        }
        
        init() {
            
        }
    }
}

extension CFQDataShim.Maimai {
    func getRatingFromSlice(songs: Array<MaimaiSongData>, slice: MaimaiBestScoreEntries) -> Int {
        slice.reduce(0) {
            $0 + $1.rating(songs: songs)
        }
    }
}
