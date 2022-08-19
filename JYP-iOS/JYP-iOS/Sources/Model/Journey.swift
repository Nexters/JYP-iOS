//
//  Journey.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/13.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

// TODO: Joruney 오래된 버전
struct Journey: Hashable {
    let id: String
    let member: [Int]
    let name: String
    let startDate: Double
    let endDate: Double
    let pikis: [Int]
    let tags: [Tag]
    let candidatePlaces: [CandidatePlace]
    let themeUrl: String
}

struct NewJourney: Hashable {
    let id: String
    let name: String
    let startDate: Double
    let endDate: Double
    let themePath: String
    let users: [User]
    let tags: [NewTag]?
    let pikis: [[Pik]]?
    let pikmis: [Pik]?
}
