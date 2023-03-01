//
//  JourneyPlanSectionModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/18.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias JourneyPlanSectionModel = SectionModel<JourneyPlanSection, JourneyPlanItem>

enum JourneyPlanSection {
    case journey([JourneyPlanItem])
}

enum JourneyPlanItem {
    case plan(PikiCollectionViewCellReactor)
    case emptyPlan(EmptyPikiCollectionViewCellReactor)
}

extension JourneyPlanSection: SectionModelType {
    typealias Item = JourneyPlanItem
    
    var items: [Item] {
        switch self {
        case let .journey(items):
            return items
        }
    }
    
    init(original: JourneyPlanSection, items: [JourneyPlanItem]) {
        switch original {
        case .journey(let items):
            self = .journey(items)
        }
    }
}
