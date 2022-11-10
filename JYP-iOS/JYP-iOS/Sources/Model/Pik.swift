//
//  Pikmi.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct Pik: Codable {
    let id: String
    let name: String
    let address: String
    let category: JYPCategoryType
    let likeBy: [User]?
    let longitude: Double
    let latitude: Double
    let link: String
}
