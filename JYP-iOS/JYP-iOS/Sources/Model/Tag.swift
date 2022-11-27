//
//  Tag.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

struct Tag: Codable {
    let topic: String
    let orientation: JYPTagType
    var users: [User] = []
    var isSelected: Bool? = false
}
