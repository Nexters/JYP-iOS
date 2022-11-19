//
//  PikiCollectionViewCellReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/11/06.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import ReactorKit

class PlanCollectionViewCellReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
        var isLast: Bool = false
        var order: Int
        var date: Date
        var pik: Pik
    }
    
    var initialState: State
    
    init(state: State) {
        initialState = state
    }
}
