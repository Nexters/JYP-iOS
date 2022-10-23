//
//  DiscussionTagSectionModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/10/23.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias DiscussionTagSectionModel = SectionModel<DiscussionTagSection, DiscussionTagItem>

enum DiscussionTagSection {
    case tag([DiscussionTagItem])
}

enum DiscussionTagItem {
    case tag(TagCollectionViewCellReactor)
}

extension DiscussionTagSection: SectionModelType {
    typealias Item = DiscussionTagItem
    
    var items: [Item] {
        switch self {
        case .tag(let items):
            return items
        }
    }
    
    init(original: DiscussionTagSection, items: [DiscussionTagItem]) {
        switch original {
        case .tag(let items):
            self = .tag(items)
        }
    }
}

