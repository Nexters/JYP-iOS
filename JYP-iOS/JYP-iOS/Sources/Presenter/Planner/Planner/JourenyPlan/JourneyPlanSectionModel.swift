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
    case dayTag([JourneyPlanItem])
    case journeyPlan([JourneyPlanItem])
}

enum JourneyPlanItem {
    case dayTag(DayTagCollectionViewCellReactor)
    case journeyPlan(JourneyPlanCollectionViewCellReactor)
}

extension JourneyPlanSection: SectionModelType {
    typealias Item = JourneyPlanItem
    
    var items: [Item] {
        switch self {
        case let .dayTag(items):
            return items
        case let .journeyPlan(items):
            return items
        }
    }
    
    init(original: JourneyPlanSection, items: [JourneyPlanItem]) {
        switch original {
        case .dayTag(let items):
            self = .dayTag(items)
        case .journeyPlan(let items):
            self = .journeyPlan(items)
        }
    }
}
