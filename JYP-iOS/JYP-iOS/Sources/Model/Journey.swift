//
//  Journey.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/13.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct Journey: Codable {
    let id, name: String
    let startDate, endDate: Double
    let themePath: ThemeType
    let users: [User]
    var tags: [Tag] = []
    var pikmis: [Pik] = []
    var pikidays: [Pikiday] = []
}
