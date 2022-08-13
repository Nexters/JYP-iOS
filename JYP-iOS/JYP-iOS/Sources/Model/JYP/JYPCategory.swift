//
//  JYPCategory.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

enum JYPCategoryType {
    case maket
    case convenienceStore
    case school
    case transportation
    case culture
    case publicPlace
    case touristPlace
    case lodging
    case restruant
    case cafe
    case hospital
    case pharmacy
    case bank
    case etc
}

extension JYPCategoryType {
    var title: String {
        switch self {
        case .maket:
            return "마트"
        case .convenienceStore:
            return "편의점"
        case .school:
            return "학교"
        case .transportation:
            return "교통"
        case .culture:
            return "문화시설"
        case .publicPlace:
            return "공공기관"
        case .touristPlace:
            return "관광지"
        case .lodging:
            return "숙소"
        case .restruant:
            return "음식점"
        case .cafe:
            return "카페"
        case .hospital:
            return "병원"
        case .pharmacy:
            return "약국"
        case .bank:
            return "은행"
        case .etc:
            return "기타"
        }
    }
    
    static func getJYPCategoryType(categoryGroupCode: String) -> JYPCategoryType {
        switch categoryGroupCode {
        case "MT1":
            return .maket
        case "CS2":
            return .convenienceStore
        case "PS3":
            return .etc
        case "SC4":
            return .school
        case "AC5":
            return .etc
        case "PK6":
            return .etc
        case "OL7":
            return .etc
        case "SW8":
            return .etc
        case "BK9":
            return .bank
        case "CT1":
            return .culture
        case "AG2":
            return .etc
        case "PO3":
            return .publicPlace
        case "AT4":
            return .touristPlace
        case "AD5":
            return .lodging
        case "FD6":
            return .restruant
        case "CE7":
            return .cafe
        case "HP8":
            return .hospital
        case "PM9":
            return .pharmacy
        default:
            return .etc
        }
    }
}
