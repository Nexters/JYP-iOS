//
//  PlannerRouteSectionModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias PlannerRouteSectionModel = SectionModel<PlannerRouteSection, PlannerRouteItem>

enum PlannerRouteSection {
    case route([PlannerRouteItem])
    case pikmiRoute([PlannerRouteItem])
}

enum PlannerRouteItem {
    case route(RouteCollectionViewCellReactor)
    case pikmiRoute(PikmiRouteCollectionViewCellReactor)
}

extension PlannerRouteSection: SectionModelType {
    typealias Item = PlannerRouteItem
    
    var items: [Item] {
        switch self {
        case let .route(items):
            return items
        case let .pikmiRoute(items):
            return items
        }
    }
    
    init(original: PlannerRouteSection, items: [PlannerRouteItem]) {
        switch original {
        case let .route(items):
            self = .route(items)
        case let .pikmiRoute(items):
            self = .pikmiRoute(items)
        }
    }
}
