//
//  JourneyPlaceSectionModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias PikiSectionModel = SectionModel<PikiSection, PikiItem>

enum PikiSection {
    case piki([PikiItem])
}

enum PikiItem {
    case piki(PikiCollectionViewCellReactor)
}

extension PikiSection: SectionModelType {
    typealias Item = PikiItem
    
    var items: [Item] {
        switch self {
        case .piki(let items):
            return items
        }
    }
    
    init(original: PikiSection, items: [PikiItem]) {
        switch original {
        case .piki(let items):
            self = .piki(items)
        }
    }
}
