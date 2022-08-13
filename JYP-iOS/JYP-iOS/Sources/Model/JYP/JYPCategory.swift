//
//  JYPCategory.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

enum JYPCategoryType {
    case maket
    case convenienceStore
    case school
    case transportation
    case culturalInstitution
    case publicInstitutions
    case touristSpot
    case lodgings
    case restruant
    case cafe
    case hospital
    case pharmacy
    case bank
    case chargingZone
    case parkingLot
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
        case .culturalInstitution:
            return "문화시설"
        case .publicInstitutions:
            return "공공기관"
        case .touristSpot:
            return "관광지"
        case .lodgings:
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
        case .chargingZone:
            return "충전소"
        case .parkingLot:
            return "주차장"
        case .etc:
            return "기타"
        }
    }
    
    var image: UIImage {
        switch self {
        case .maket:
            return JYPIOSAsset.iconMarket.image
        case .convenienceStore:
            return JYPIOSAsset.iconConvenienceStore.image
        case .school:
            return JYPIOSAsset.iconSchool.image
        case .transportation:
            return JYPIOSAsset.iconTransportation.image
        case .culturalInstitution:
            return JYPIOSAsset.iconCulturalInstitution.image
        case .publicInstitutions:
            return JYPIOSAsset.iconPublicInstitutions.image
        case .touristSpot:
            return JYPIOSAsset.iconTouristSpot.image
        case .lodgings:
            return JYPIOSAsset.iconLodgings.image
        case .restruant:
            return JYPIOSAsset.iconRestaurant.image
        case .cafe:
            return JYPIOSAsset.iconCafe.image
        case .hospital:
            return JYPIOSAsset.iconHospital.image
        case .pharmacy:
            return JYPIOSAsset.iconPharmacy.image
        case .bank:
            return JYPIOSAsset.iconBank.image
        case .etc:
            return JYPIOSAsset.iconEtc.image
        case .chargingZone:
            return JYPIOSAsset.iconChargingZone.image
        case .parkingLot:
            return JYPIOSAsset.iconParkingLot.image
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
            return .culturalInstitution
        case "AG2":
            return .etc
        case "PO3":
            return .publicInstitutions
        case "AT4":
            return .touristSpot
        case "AD5":
            return .lodgings
        case "FD6":
            return .restruant
        case "CE7":
            return .cafe
        case "HP8":
            return .hospital
        case "PM9":
            return .pharmacy
        case "OL7":
            return .chargingZone
        case "PK6":
            return .parkingLot
        default:
            return .etc
        }
    }
}
