//
//  FetchJourneyDetailResponse.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/12/25.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct FetchJourneyDetailResponse: Codable {
    let id, name: String
    let startDate, endDate: Double
    let themePath: String
    let users: [User]
    let tags: [Tag]
    let pikmis: [Pik]
    let pikidays: [Pikiday]
}

extension FetchJourneyDetailResponse {
    func toDomain() -> Journey {
        Journey(
            id: self.id,
            name: self.name,
            startDate: self.startDate,
            endDate: self.endDate,
            themePath: ThemeType(rawValue: self.themePath) ?? ThemeType.default,
            users: self.users,
            tags: self.tags,
            pikmis: self.pikmis,
            pikidays: self.pikidays
        )
    }
}
