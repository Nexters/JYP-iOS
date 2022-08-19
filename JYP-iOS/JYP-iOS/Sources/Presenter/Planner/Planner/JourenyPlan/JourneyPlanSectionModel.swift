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
    case journeyPlan([JourneyPlanItem])
}

enum JourneyPlanItem {
    case journeyPlan(JourneyPlanCollectionViewCellReactor)
}

extension JourneyPlanSection: SectionModelType {
    typealias Item = JourneyPlanItem
    
    var items: [Item] {
        switch self {
        case .journeyPlan(let items):
            return items
        }
    }
    
    init(original: JourneyPlanSection, items: [JourneyPlanItem]) {
        switch original {
        case .journeyPlan(let items):
            self = .journeyPlan(items)
        }
    }
}
