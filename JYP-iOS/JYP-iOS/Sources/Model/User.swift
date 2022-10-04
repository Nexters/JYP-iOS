//
//  User.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct User: Codable {
    let id: String
    let nickname: String
    let profileImagePath: String
    let personality: PersonalityId
    
    enum CodingKeys: String, CodingKey {
        case id, profileImagePath, personality
        case nickname = "name"
    }
}
