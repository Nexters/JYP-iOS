//
//  Journey.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/13.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct Journey: Hashable {
    let id: String
    let member: [Int]
    let name: String
    let startDate: Double
    let endDate: Double
    let pikis: [Int]
    let candidatePlaces: [CandidatePlace]
    let themeUrl: String
}
