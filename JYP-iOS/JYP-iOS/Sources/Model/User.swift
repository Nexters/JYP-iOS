//
//  User.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

enum AuthVendor: Codable {
    case kakao
    case apple
}

enum PersonalityId: Codable {
    case ME
    case PE
    case RT
    case FW
}

struct User: Hashable {
    let id: String
    let nickname: String
    let profileImagePath: String
    let personality: String
}

struct UserUpdate: Codable {
    let name: String
    let profileImagePath: String
}

struct UserSignup: Codable {
    let authVendor: AuthVendor
    let authID, name, profileImagePath: String
    let personalityID: PersonalityId

    enum CodingKeys: String, CodingKey {
        case authVendor
        case authID = "authId"
        case name, profileImagePath
        case personalityID = "personalityId"
    }
}
