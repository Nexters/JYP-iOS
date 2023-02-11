//
//  MyPageReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/01/14.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import ReactorKit

class MyPageReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
        case setDismiss(Bool)
    }

    struct State {
        var dismiss: Bool = false
    }
    
    var initialState: State
    
    private let userService: UserServiceType
    
    init(userService: UserServiceType) {
        self.userService = userService
        self.initialState = State()
    }
}

extension MyPageReactor {
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let userEvnetMutation = userService.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .logout:
                return .just(.setDismiss(true))
                
            default:
                return .empty()
            }
            
        }
        
        return .merge(mutation, userEvnetMutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setDismiss(bool):
            newState.dismiss = bool
        }
        
        return newState
    }
}
