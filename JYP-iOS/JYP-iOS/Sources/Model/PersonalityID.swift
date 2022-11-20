//
//  PersonalityId.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/21.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

enum PersonalityID: String, Codable {
    case ME
    case PE
    case RT
    case FW
    
    static func intsToPersonalityID(data: [Int]) -> PersonalityID {
        var sum: Int = 0
        
        for (i, int) in data.enumerated() {
            sum += Int(pow(Double(2), Double(i))) * int
        }
        
        switch sum  {
        case 0, 1:
            return .ME
            
        case 2, 4:
            return .PE
            
        case 3, 5:
            return .RT
            
        default:
            return .FW
        }
    }
}
