//
//  UserUpdateRequest.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/21.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct UserUpdateRequest: Codable {
    let name: String
    let profileImagePath: String
}
