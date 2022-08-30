//
//  PikmiRouteSectionModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias PikmiRouteSectionModel = SectionModel<PikmiRouteSection, PikmiRouteItem>

enum PikmiRouteSection {
    case pikmiRoute([PikmiRouteItem])
}

enum PikmiRouteItem {
    case pikmiRoute(PikmiRouteCollectionViewCellReactor)
}

extension PikmiRouteSection: SectionModelType {
    typealias Item = PikmiRouteItem
    
    var items: [Item] {
        switch self {
        case let .pikmiRoute(items):
            return items
        }
    }
    
    init(original: PikmiRouteSection, items: [PikmiRouteItem]) {
        switch original {
        case let .pikmiRoute(items):
            self = .pikmiRoute(items)
        }
    }
}
