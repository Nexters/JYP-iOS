//
//  Journey.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/13.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct Journey: Codable {
    let id: String
    let name: String
    let startDate: Double
    let endDate: Double
    let themePath: ThemeType
    let users: [User]
    var tags: [Tag] = []
    var pikis: [[Pik]] = []
    var pikmis: [Pik] = []
}
