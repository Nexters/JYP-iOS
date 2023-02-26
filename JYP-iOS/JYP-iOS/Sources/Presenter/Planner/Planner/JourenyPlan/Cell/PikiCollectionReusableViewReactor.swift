//
//  PikiCollectionReusableViewReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/03.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import ReactorKit

class PikiCollectionReusableViewReactor: Reactor {
    enum Action { }
    enum Mutation { }
    
    struct State {
        let index: Int
        let date: Date
    }
    
    var initialState: State
    
    init(index: Int, date: Date) {
        self.initialState = .init(index: index, date: date)
    }
}
