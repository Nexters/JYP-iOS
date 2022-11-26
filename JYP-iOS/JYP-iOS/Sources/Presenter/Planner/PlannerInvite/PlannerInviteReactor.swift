//
//  PlannerInviteReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class PlannerInviteReactor: Reactor {
    enum Action {
    }
    
    enum Mutation {
    }
    
    struct State {
        var id: String
    }
    
    var initialState: State
    
    init(id: String) {
        self.initialState = State(id: id)
    }
}
