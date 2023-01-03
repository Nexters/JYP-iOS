//
//  PlannerInviteReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class PlannerInviteReactor: Reactor {
    enum Action { }
    
    enum Mutation { }
    
    struct State { }
    
    var initialState: State
    
    let id: String
    
    init(id: String) {
        self.id = id
        self.initialState = .init()
    }
}
