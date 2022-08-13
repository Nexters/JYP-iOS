//
//  PlannerSearchPlaceSectionModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/13.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias PlannerSearchPlaceSectionModel = SectionModel<PlannerSearchPlaceSection, PlannerSearchPlaceItem>

enum PlannerSearchPlaceSection {
    case kakaoSection([PlannerSearchPlaceItem])
}

enum PlannerSearchPlaceItem {
    case kakaoItem(KakaoSearchPlaceTableViewCellReactor)
}

extension PlannerSearchPlaceSection: SectionModelType {
    typealias Item = PlannerSearchPlaceItem
    
    var items: [Item] {
        switch self {
        case let .kakaoSection(items): return items
        }
    }
    
    init(original: PlannerSearchPlaceSection, items: [PlannerSearchPlaceItem]) {
        switch original {
        case let .kakaoSection(items):
            self = .kakaoSection(items)
        }
    }
}
