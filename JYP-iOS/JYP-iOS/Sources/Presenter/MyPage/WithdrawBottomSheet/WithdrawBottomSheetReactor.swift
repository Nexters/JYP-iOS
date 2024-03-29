//
//  WithdrawBottomSheetReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/02/11.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import ReactorKit

class WithdrawBottomSheetReactor: Reactor {
    enum Action {
        case tap
    }
    
    enum Mutation {
        case setDismiss(Bool)
    }
    
    struct State {
        var dismiss: Bool = false
    }
    
    var initialState: State
    
    let userService: UserServiceType
    
    init(userService: UserServiceType) {
        self.userService = userService
        self.initialState = .init()
    }
}

extension WithdrawBottomSheetReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tap:
            if let id = UserDefaultsAccess.get(key: .userID) {
                userService.deleteUser(id: id)
            }
            return .empty()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let userEventMutation = userService.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .withdraw:
                return .just(.setDismiss(true))
                
            default:
                return .empty()
            }
        }
        
        return .merge(mutation, userEventMutation)
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
