//
//  JourneysResponse.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/11/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct FetchJourneysResponse: Codable {
    let journeys: [JourneyResponse]
}

extension FetchJourneysResponse {
    func toDomain() -> [Journey] {
        journeys.map {
            Journey(
                id: $0.id,
                name: $0.name,
                startDate: $0.startDate,
                endDate: $0.endDate,
                themePath: ThemeType(rawValue: $0.themePath) ?? ThemeType.default,
                users: $0.users
            )
        }
    }
}

struct JourneyResponse: Codable {
    let id: String
    let name: String
    let startDate: Double
    let endDate: Double
    let themePath: String
    let users: [User]
}
