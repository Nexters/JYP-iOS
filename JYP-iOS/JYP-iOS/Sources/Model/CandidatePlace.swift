//
//  CandidatePlace.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct CandidatePlace: Hashable {
    let id: String
    let name: String
    let address: String
    let category: JYPCategoryType
    let like: String
//    let like: [User]
    let lon, lan: Double
    let url: String
}
