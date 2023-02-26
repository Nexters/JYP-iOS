//
//  EmptyPikiCollectionViewCellReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/02/26.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import Foundation

import ReactorKit

class EmptyPikiCollectionViewCellReactor: Reactor {
    enum Action { }
    enum Mutation { }
    
    struct State {
        let index: Int
        let startDate: Date
    }

    var initialState: State
    
    init(index: Int, startDate: Date) {
        initialState = .init(index: index, startDate: startDate)
    }
}
