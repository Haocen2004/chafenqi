//
//  FilterExtension.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/2/28.
//

import Foundation

extension Array<ChunithmSongData> {
    func filterTitle(keyword: String) -> Array<ChunithmSongData> {
        self.filter {
            $0.basicInfo.title.lowercased().contains(keyword.lowercased())
        }
    }
    
    func filterArtist(keyword: String) -> Array<ChunithmSongData> {
        self.filter {
            $0.basicInfo.artist.lowercased().contains(keyword.lowercased())
        }
    }
    
    func filterCombo(levelIndex: Int, lower: Int, upper: Int) -> Array<ChunithmSongData> {
        self.filter {
            lower...upper ~= $0.charts[levelIndex].combo
        }
    }
    
    func filterGenre(keyword: String) -> Array<ChunithmSongData> {
        self.filter {
            $0.basicInfo.genre == keyword
        }
    }
    
    func filterPlayed(idList: Array<Int>) -> Array<ChunithmSongData> {
        self.filter {
            idList.contains($0.musicId)
        }
    }
}
