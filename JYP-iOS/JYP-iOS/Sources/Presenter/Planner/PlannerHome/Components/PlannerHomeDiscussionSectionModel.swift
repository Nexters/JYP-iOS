//
//  DiscussionHomeJYPTagSectionModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias PlannerHomeDiscussionSectionModel = SectionModel<PlannerHomeDiscussionSection, PlannerHomeDiscussionItem>

enum PlannerHomeDiscussionSection {
    case jypTagSection([PlannerHomeDiscussionItem])
    case candidatePlaceSection([PlannerHomeDiscussionItem])
}

enum PlannerHomeDiscussionItem {
    case jypTagItem(JYPTagCollectionViewCellReactor)
    case candidatePlaceItem(CandidatePlaceCollectionViewCellReactor)
}

extension PlannerHomeDiscussionSection: SectionModelType {
    typealias Item = PlannerHomeDiscussionItem
    
    var items: [Item] {
        switch self {
        case .jypTagSection(let items):
            return items
        case .candidatePlaceSection(let items):
            return items
        }
    }
    
    init(original: PlannerHomeDiscussionSection, items: [PlannerHomeDiscussionItem]) {
        switch original {
        case .jypTagSection(let items):
            self = .jypTagSection(items)
        case .candidatePlaceSection(let items):
            self = .candidatePlaceSection(items)
        }
    }
}
