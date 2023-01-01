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
        let journey: Journey?
        let order: Int
    }
    
    var initialState: State
    
    init(journey: Journey?, order: Int) {
        self.initialState = .init(journey: journey, order: order)
    }
}
