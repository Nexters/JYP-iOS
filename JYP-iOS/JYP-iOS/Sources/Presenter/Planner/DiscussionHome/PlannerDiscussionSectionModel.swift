//
//  DiscussionHomeJYPTagSectionModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias PlannerDiscussionSectionModel = SectionModel<PlannerDiscussionSection, PlannerDiscussionItem>

enum PlannerDiscussionSection {
    case jypTagSection([PlannerDiscussionItem])
    case candidatePlaceSection([PlannerDiscussionItem])
}

enum PlannerDiscussionItem {
    case jypTagItem(JYPTagCollectionViewCellReactor)
    case candidatePlaceItem(CandidatePlaceCollectionViewCellReactor)
}

extension PlannerDiscussionSection: SectionModelType {
    typealias Item = PlannerDiscussionItem
    
    var items: [Item] {
        switch self {
        case .jypTagSection(let items):
            return items
        case .candidatePlaceSection(let items):
            return items
        }
    }
    
    init(original: PlannerDiscussionSection, items: [PlannerDiscussionItem]) {
        switch original {
        case .jypTagSection(let items):
            self = .jypTagSection(items)
        case .candidatePlaceSection(let items):
            self = .candidatePlaceSection(items)
        }
    }
}
