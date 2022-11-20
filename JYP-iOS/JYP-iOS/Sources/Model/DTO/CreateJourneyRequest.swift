//
//  CreateJourneyRequest.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/11/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct CreateJourneyRequest: Codable {
    let name: String
    let startDate, endDate: Double
    let themePath: String
    let tags: [Tag]
}
