//
//  DiscussionPikmiSectionModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/10/23.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias DiscussionPikmiSectionModel = SectionModel<DiscussionPikmiSection, DiscussionPikmiItem>

enum DiscussionPikmiSection {
    case pikmi([DiscussionPikmiItem])
}

enum DiscussionPikmiItem {
    case createPikmi(CreatePikmiCollectionViewCellReactor)
    case pikmi(PikmiCollectionViewCellReactor)
}

extension DiscussionPikmiSection: SectionModelType {
    typealias Item = DiscussionPikmiItem
    
    var items: [Item] {
        switch self {
        case .pikmi(let items):
            return items
        }
    }
    
    init(original: DiscussionPikmiSection, items: [DiscussionPikmiItem]) {
        switch original {
        case .pikmi(let items):
            self = .pikmi(items)
        }
    }
}
