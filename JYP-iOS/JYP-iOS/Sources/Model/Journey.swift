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
    var name: String
    var startDate, endDate: Double
    var themePath: ThemeType
    var users: [User]
    var tags: [Tag] = []
    var pikmis: [Pik] = []
    var pikidays: [Pikiday] = []
}
