//
//  RouteCollectionViewCellReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class RouteCollectionViewCellReactor: Reactor {
    enum Action { }
    enum Mutation { }
    struct State {
        let pik: Pik?
    }
    
    var initialState: State
    
    init(state: State) {
        self.initialState = state
    }
}
