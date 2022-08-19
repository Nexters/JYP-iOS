//
//  JourneyPlaceCollectionViewCellReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class JourneyPlaceCollectionViewCellReactor: Reactor {
    typealias Action = NoAction
    
    var initialState: CandidatePlace
    
    init(state: CandidatePlace) {
        initialState = state
    }
}