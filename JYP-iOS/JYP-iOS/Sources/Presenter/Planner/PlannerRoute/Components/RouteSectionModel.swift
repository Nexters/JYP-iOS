//
//  RouteSectionModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias RouteSectionModel = SectionModel<RouteSection, RouteItem>

enum RouteSection {
    case route([RouteItem])
}

enum RouteItem {
    case route(RouteCollectionViewCellReactor)
}

extension RouteSection: SectionModelType {
    typealias Item = RouteItem
    
    var items: [Item] {
        switch self {
        case let .route(items):
            return items
        }
    }
    
    init(original: RouteSection, items: [RouteItem]) {
        switch original {
        case let .route(items):
            self = .route(items)
        }
    }
}
