//
//  UserScoreData.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/1/17.
//

import Foundation
import SwiftUI

struct ChunithmUserScoreData: Codable {
    static let shared = ChunithmUserScoreData(nickname: "", rating: 0.0, records: ScoreRecord(b30: [], r10: []), username: "")
    
    struct ScoreRecord: Codable {
        var b30: Array<ScoreEntry>
        var r10: Array<ScoreEntry>
    }
    
    var nickname: String
    var rating: Double
    var records: ScoreRecord
    var username: String
    
    func getAvgB30() -> Double {
        let best = self.records.b30.sorted {
            $0.rating > $1.rating
        }
        
        let length = best.count > 29 ? 30 : best.count
        let b30 = best.prefix(upTo: length)
        
        var avg: Double = 0.0
        b30.forEach { entry in
            avg += entry.rating
        }
        return avg / 30.0
    }
    
    func getAvgR10() -> Double {
        var avg: Double = 0.0
        self.records.r10.forEach { entry in
            avg += entry.rating
        }
        return avg / 10.0
    }
    
    func getRating() -> Double {
        return ((getAvgB30() * 30.0 + getAvgR10() * 10.0 ) / 40.0).cut(remainingDigits: 2)
    }
    
    func getMaximumRating() -> Double {
        var b1 = 0.0
        let array = self.records.b30.sorted {
            $0.rating > $1.rating
        }
        
        if (!array.isEmpty) {
            b1 = array[0].rating
        }
        
        return ((getAvgB30() * 30.0 + b1 * 10.0) / 40.0).cut(remainingDigits: 2)
    }
    
    func getRelativeR10Percentage() -> Double {
        let b1 = self.records.b30.sorted {
            $0.rating > $1.rating
        }[0]
        
        if (abs(getAvgR10() - b1.rating) > 1) {
            return getAvgR10() / b1.rating
        } else {
            let head = Int(getAvgR10())
            return (getAvgR10() - Double(head)) / (b1.rating - Double(head))
        }
    }
    
    func getRelativePercentage() -> Double {
        if (abs(self.rating - getMaximumRating()) > 1) {
            return self.rating / getMaximumRating()
        } else {
            let head = Int(self.rating)
            return (self.rating - Double(head)) / (getMaximumRating() - Double(head))
        }
    }
}
