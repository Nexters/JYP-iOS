//
//  Pikmi.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct Pikiday: Codable {
    let pikis: [Pik]
}

struct Pik: Codable {
    let id, name, address: String
    let category: JYPCategoryType
    let likeBy: [User]?
    let longitude, latitude: Double
    let link: String
}
