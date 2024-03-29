//
//  ThemeType.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

enum ThemeType: String, CaseIterable, Codable {
    case `default` = "https://journeypiki.duckdns.org/static/theme_basic.png"
    case sea = "https://journeypiki.duckdns.org/static/theme_beach.png"
    case mountain = "https://journeypiki.duckdns.org/static/theme_mountain.png"
    case culture = "https://journeypiki.duckdns.org/static/theme_historic_spot.png"
    case city = "https://journeypiki.duckdns.org/static/theme_city.png"

    var image: UIImage {
        switch self {
        case .default: return JYPIOSAsset.cardIllust1.image
        case .sea: return JYPIOSAsset.cardIllust2.image
        case .mountain: return JYPIOSAsset.cardIllust3.image
        case .culture: return JYPIOSAsset.cardIllust4.image
        case .city: return JYPIOSAsset.cardIllust5.image
        }
    }

    var cardColor: UIColor {
        switch self {
        case .default: return JYPIOSAsset.backgroundWhite100.color
        case .sea: return .init(hex: 0x88C4FF)
        case .mountain: return .init(hex: 0xF15077)
        case .culture: return .init(hex: 0xFFA451)
        case .city: return JYPIOSAsset.subBlue200.color
        }
    }

    var borderColor: UIColor {
        switch self {
        case .default: return JYPIOSAsset.backgroundWhite100.color
        case .sea: return .init(hex: 0x57ABFF)
        case .mountain: return .init(hex: 0xEF597D)
        case .culture: return .init(hex: 0xFFA95B)
        case .city: return .init(hex: 0x58C6E9)
        }
    }

    var textColor: UIColor {
        switch self {
        case .default: return JYPIOSAsset.textB80.color
        default: return JYPIOSAsset.textWhite.color
        }
    }

    var isActiveShadow: Bool {
        switch self {
        case .default: return true
        default: return false
        }
    }

    var themeName: String {
        switch self {
        case .default: return "기본"
        case .city: return "도시"
        case .culture: return "문화 유적"
        case .sea: return "바다"
        case .mountain: return "산"
        }
    }
}
