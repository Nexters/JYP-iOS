//
//  JourneyPlanCollectionViewCellReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/18.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class JourneyPlanCollectionViewCellReactor: Reactor {
    typealias Action = NoAction
    
    let initialState: [PikiSectionModel]
    
    init(state: [PikiSectionModel]) {
        initialState = state
    }
}
