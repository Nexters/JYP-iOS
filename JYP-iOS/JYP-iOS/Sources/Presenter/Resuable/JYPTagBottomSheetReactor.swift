//
//  JYPTagBottomSheetReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/13.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class JYPTagBottomSheetReactor: Reactor {
    enum Action { }
    
    enum Mutation { }
    
    struct State {
        let tag: Tag
    }
    
    var initialState: State
    
    init(state: State) {
        self.initialState = state
    }
}
