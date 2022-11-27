//
//  CreateUserRequest.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/11/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct CreateUserRequest: Codable {
    var authVendor: AuthVendor
    var authID, name, profileImagePath: String
    var personalityID: PersonalityID

    enum CodingKeys: String, CodingKey {
        case authVendor
        case authID = "authId"
        case name, profileImagePath
        case personalityID = "personalityId"
    }
}