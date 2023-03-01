//
//  DiscussionSectionModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources
import Foundation

typealias DiscussionSectionModel = AnimatableSectionModel<DiscussionSection, DiscussionItem>

enum DiscussionSection {
    case tag([DiscussionItem])
    case pikmi([DiscussionItem])
}

enum DiscussionItem: IdentifiableType, Equatable {
    case tag(TagCollectionViewCellReactor)
    case emptyTag
    case createPikmi(CreatePikmiCollectionViewCellReactor)
    case pikmi(PikmiCollectionViewCellReactor)
    
    var identity: some Hashable {
        switch self {
        case .tag, .emptyTag, .createPikmi:
            return UUID().uuidString
        case let .pikmi(reactor):
            return reactor.currentState.pik.id
        }
    }
    
    static func == (lhs: DiscussionItem, rhs: DiscussionItem) -> Bool {
        lhs.identity == rhs.identity
    }
}

extension DiscussionSection: AnimatableSectionModelType {
    typealias Item = DiscussionItem
    
    var identity: String {
        return "\(items.count)"
    }
    
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
