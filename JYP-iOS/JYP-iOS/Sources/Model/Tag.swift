//
//  Tag.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

// TODO: Joruney 오래된 버전
struct Tag: Hashable {
    let id: String
    let text: String
    let type: JYPTagType
    var isSelected: Bool = false
}

struct NewTag: Hashable {
    let topic: String
    let orientation: JYPTagType
    let users: [User]?
}
