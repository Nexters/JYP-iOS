//
//  OnboardingReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/18.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class OnboardingReactor: Reactor {
    enum Action {
        case didTapNextButton
    }
    
    enum Mutation {
        case updateIsPresentNextViewController(Bool)
    }
    
    struct State {
        var isPresentNextViewController: Bool = false
    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
}

extension OnboardingReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNextButton:
            return .just(.updateIsPresentNextViewController(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .updateIsPresentNextViewController(let bool):
            newState.isPresentNextViewController = bool
        }
        
        return newState
    }
}
