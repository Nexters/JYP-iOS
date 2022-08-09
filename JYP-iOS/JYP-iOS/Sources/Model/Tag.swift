//
//  Tag.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/09.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct Tag: Hashable {
    let id: String
    let text: String
    let type: TagType
}

enum TagType {
    case soso
    case like
    case dislike
}
