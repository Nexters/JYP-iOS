//
//  SignupRequest.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/21.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct SignupRequest: Codable {
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
