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
    var isSelected: Bool = false

    init(topic: String, orientation: JYPTagType, users: [User]) {
        self.topic = topic
        self.orientation = orientation
        self.users = users
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        topic = try container.decode(String.self, forKey: .topic)
        orientation = try container.decode(JYPTagType.self, forKey: .orientation)
        users = (try? container.decode([User].self, forKey: .users)) ?? []
        isSelected = (try? container.decode(Bool.self, forKey: .users)) ?? false
    }
}
