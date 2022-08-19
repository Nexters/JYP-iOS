//
//  DiscussionHomeJYPTagSectionModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias OldPlannerHomeDiscussionSectionModel = SectionModel<OldPlannerHomeDiscussionSection, OldPlannerHomeDiscussionItem>

enum OldPlannerHomeDiscussionSection {
    case jypTagSection([OldPlannerHomeDiscussionItem])
    case candidatePlaceSection([OldPlannerHomeDiscussionItem])
}

enum OldPlannerHomeDiscussionItem {
    case jypTagItem(JYPTagCollectionViewCellReactor)
    case createCandidatePlaceItem(CreatePikmiCollectionViewCellReactor)
    case candidatePlaceItem(PikmiCollectionViewCellReactor)
}

extension OldPlannerHomeDiscussionSection: SectionModelType {
    typealias Item = OldPlannerHomeDiscussionItem
    
    var items: [Item] {
        switch self {
        case .jypTagSection(let items):
            return items
        case .candidatePlaceSection(let items):
            return items
        }
    }
    
    init(original: OldPlannerHomeDiscussionSection, items: [OldPlannerHomeDiscussionItem]) {
        switch original {
        case .jypTagSection(let items):
            self = .jypTagSection(items)
        case .candidatePlaceSection(let items):
            self = .candidatePlaceSection(items)
        }
    }
}
