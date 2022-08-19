//
//  JourneyPlaceSectionModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias JourneyPlaceSectionModel = SectionModel<JourneyPlaceSection, JourneyPlaceItem>

enum JourneyPlaceSection {
    case journeyPlace([JourneyPlaceItem])
}

enum JourneyPlaceItem {
    case journeyPlace(JourneyPlaceCollectionViewCellReactor)
}

extension JourneyPlaceSection: SectionModelType {
    typealias Item = JourneyPlaceItem
    
    var items: [Item] {
        switch self {
        case .journeyPlace(let items):
            return items
        }
    }
    
    init(original: JourneyPlaceSection, items: [JourneyPlaceItem]) {
        switch original {
        case .journeyPlace(let items):
            self = .journeyPlace(items)
        }
    }
}
