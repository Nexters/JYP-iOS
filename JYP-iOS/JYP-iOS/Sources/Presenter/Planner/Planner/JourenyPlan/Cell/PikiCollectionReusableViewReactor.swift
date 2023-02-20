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
        let order: Int
        let date: Double
    }
    
    var initialState: State
    
    init(order: Int, date: Double) {
        self.initialState = .init(order: order, date: date)
    }
}
