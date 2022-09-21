//
//  PersonalityId.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/21.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

enum PersonalityId: Codable {
    case ME
    case PE
    case RT
    case FW
    
    static func intsToPersonalityId(ints: [Int]) -> PersonalityId {
        if ints == [0, 0, 0] || ints == [1, 0, 0] {
            return .ME
        } else if ints == [0, 1, 0] || ints == [0, 0, 1] {
            return .PE
        } else if ints == [1, 1, 0] || ints == [1, 0, 1] {
            return .RT
        } else {
            return .FW
        }
    }
}
