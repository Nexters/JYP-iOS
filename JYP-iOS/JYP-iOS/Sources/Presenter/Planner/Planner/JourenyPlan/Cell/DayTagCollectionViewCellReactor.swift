//
//  DayTagCollectionViewCellReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/20.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class DayTagCollectionViewCellReactor: Reactor {
    enum Action {}
    enum Mutation {}
    
    struct State {
        let day: Int
    }
    
    var initialState: State
    
    init(state: State) {
        self.initialState = state
    }
}
