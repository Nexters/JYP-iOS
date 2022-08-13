//
//  Tag.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

struct Tag: Hashable {
    let id: String
    let text: String
    let type: JYPTagType
    var isSelected: Bool = false
}
