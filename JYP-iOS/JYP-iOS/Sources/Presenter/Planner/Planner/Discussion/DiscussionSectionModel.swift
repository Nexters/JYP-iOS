//
//  DiscussionSectionModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias DiscussionSectionModel = SectionModel<DiscussionSection, DiscussionItem>

enum DiscussionSection {
    case tag([DiscussionItem])
    case pikmi([DiscussionItem])
}

enum DiscussionItem {
    case tag(JYPTagCollectionViewCellReactor)
    case createPikmi(CreatePikmiCollectionViewCellReactor)
    case pikmi(PikmiCollectionViewCellReactor)
}

extension DiscussionSection: SectionModelType {
    typealias Item = DiscussionItem
    
    var items: [Item] {
        switch self {
        case .tag(let items):
            return items
        case .pikmi(let items):
            return items
        }
    }
    
    init(original: DiscussionSection, items: [DiscussionItem]) {
        switch original {
        case .tag(let items):
            self = .tag(items)
        case .pikmi(let items):
            self = .pikmi(items)
        }
    }
}
