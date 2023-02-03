//
//  MaimaiPlayerProfile.swift
//  chafenqi
//
//  Created by 刘易斯 on 2023/2/3.
//

import Foundation

struct MaimaiPlayerProfile: Codable {
    var additionalRating: String
    var bindQQ: String
    var nickname: String
    var plate: String
    var privacy: Bool
    var username: String
    
    enum CodingKeys: String, CodingKey {
        case additionalRating = "additional_rating"
        case bindQQ = "bind_qq"
        case nickname
        case plate
        case privacy
        case username
    }
}
