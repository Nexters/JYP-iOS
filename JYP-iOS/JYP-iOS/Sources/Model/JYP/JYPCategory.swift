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
