//
//  kakaoResponse.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/22.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

// MARK: - KakaoResponse

struct KakaoResponse: Codable {
    let meta: Meta
    let documents: [Document]
}

// MARK: - Document

struct Document: Codable {
    let id, placeName, categoryName, categoryGroupCode: String
    let categoryGroupName, phone, addressName, roadAddressName: String
    let x, y: String
    let placeURL: String
    let distance: String

    enum CodingKeys: String, CodingKey {
        case id
        case placeName = "place_name"
        case categoryName = "category_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case phone
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case x, y
        case placeURL = "place_url"
        case distance
    }
}

// MARK: - Meta

struct Meta: Codable {
    let totalCount, pageableCount: Int
    let isEnd: Bool
    let sameName: SameName

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
        case sameName = "same_name"
    }
}

// MARK: - SameName

struct SameName: Codable {
    let region: [String]
    let keyword, selectedRegion: String

    enum CodingKeys: String, CodingKey {
        case region, keyword
        case selectedRegion = "selected_region"
    }
}
