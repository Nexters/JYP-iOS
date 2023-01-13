//
//  PersonalityId.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/21.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

enum PersonalityID: String, Codable {
    case ME = "꼼꼼한 탐험가"
    case PE = "열정왕 탐험가"
    case RT = "낭만적인 여행자"
    case FW = "자유로운 방랑자"
    
    static func toSelf(journey: Bool, place: Bool, plan: Bool) -> PersonalityID {
        if (journey && place && plan) || ((journey == false && place && plan)) {
            return .ME
        } else if (journey && place == false && plan) || ((journey && place && plan == false)) {
            return .PE
        } else if (journey == false && place == false && plan) || ((journey == false && place && plan == false)) {
            return .RT
        } else {
            return .FW
        }
    }
}
