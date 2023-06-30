//
//  UserInfoFetcher.swift
//  chafenqi
//
//  Created by xinyue on 2023/6/28.
//

import Foundation
import UIKit
import CoreData

struct UserInfoFetcher {
    static let decoder = JSONDecoder()
    static let session = URLSession.shared
    
    static var isPremium = false
    static var maimai: CFQMaimai.UserInfo?
    static var chunithm: CFQChunithm.UserInfo?
    static var maiRecentOne: CFQMaimai.RecentScoreEntry?
    static var chuRecentOne: CFQChunithm.RecentScoreEntry?
    
    static var cachedMaiCover = Data()
    static var cachedChuCover = Data()


    static func refreshData() async throws {
        if let currentUser = UserDefaults(suiteName: "group.com.nltv.chafenqi.shared")?.string(forKey: "currentUser") {
            NSLog("[CFQWidget] Current user: " + currentUser)
            let info = try self.fetchBy(username: currentUser)
            if let info = info {
                self.isPremium = info.isPremium
                NSLog("[CFQWidget] Premium: " + (isPremium ? "true" : "false"))
                if let maiData = info.maimai {
                    self.maimai = try decoder.decode(CFQMaimai.UserInfo.self, from: maiData)
                }
                if let chuData = info.chunithm {
                    self.chunithm = try decoder.decode(CFQChunithm.UserInfo.self, from: chuData)
                }
                if let maiRecentOne = info.maiRecentOne {
                    NSLog("[CFQWidget] Found maimai recent data")
                    self.maiRecentOne = try decoder.decode(CFQMaimai.RecentScoreEntry.self, from: maiRecentOne)
                }
                if let chuRecentOne = info.chuRecentOne {
                    NSLog("[CFQWidget] Found chunithm recent data")
                    self.chuRecentOne = try decoder.decode(CFQChunithm.RecentScoreEntry.self, from: chuRecentOne)
                }
                self.cachedMaiCover = info.maiCover ?? Data()
                self.cachedChuCover = info.chuCover ?? Data()
            }
        }
    }
    
    static func fetchBy(username: String) throws -> WidgetUser? {
        let predicate = NSPredicate(format: "username == %@", username)
        let request = WidgetUser.fetchRequest()
        request.predicate = predicate
        let entries = try WidgetDataController.shared.container.viewContext.fetch(request)
        return entries.first
    }
}


