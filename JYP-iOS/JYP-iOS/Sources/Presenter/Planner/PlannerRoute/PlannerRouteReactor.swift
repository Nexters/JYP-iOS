//
//  PlannerRouteReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import ReactorKit

class PlannerRouteReactor: Reactor {
    enum Action { }
    enum Mutation { }
    
    struct State {
        let order: Int
        let date: Date
    }
    
    var initialState: State
    
    init(state: State) {
        self.initialState = state
    }
}
