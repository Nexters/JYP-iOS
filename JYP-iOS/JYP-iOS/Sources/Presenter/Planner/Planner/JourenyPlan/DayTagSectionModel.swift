//
//  DayTagSectionModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/20.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias DayTagSectionModel = SectionModel<DayTagSection, DayTagItem>

enum DayTagSection {
    case dayTag([DayTagItem])
}

enum DayTagItem {
    case dayTag(DayTagCollectionViewCellReactor)
}

extension DayTagSection: SectionModelType {
    typealias Item = DayTagItem
    
    var items: [Item] {
        switch self {
        case let .dayTag(items):
            return items
        }
    }
    
    init(original: DayTagSection, items: [DayTagItem]) {
        switch original {
        case let .dayTag(items):
            self = .dayTag(items)
        }
    }
}
