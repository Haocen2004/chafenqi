//
//  CoverImageGrabber.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/2/27.
//

import Foundation

struct CoverImageGrabber {
    func getMaimaiURL(mode: Int, chartId: String) -> URL? {
        if (mode == 0) {
            // Diving-Fish
            return URL(string: "https://www.diving-fish.com/covers/\(getCoverNumber(id: String(song.musicId))).png")
        } else {
            return nil
        }
    }
    
    func getChunithmURL(mode: Int, chartId: String) -> URL? {
        if (mode == 0) {
            // Github
            return URL(string: "https://raw.githubusercontent.com/Louiswu2011/Chunithm-Song-Cover/main/images/\(chartId).png")
        } else if (mode == 1) {
            // NLServer
            return URL(string: "https://nltv.top/chunithm/cover?mid=\(chartId)")
        } else {
            return nil
        }
    }
}
