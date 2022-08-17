//
//  OnboardingPlaceReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class OnboardingTwoReactor: Reactor {
    enum Action {
        case didTapNextButton
    }
    
    enum Mutation {
        case setIsPresentOnboardingSignUp(Bool)
    }
    
    struct State {
        var isPresentOnboardingSignUp: Bool = false
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }

    // MARK: - Setup Reactor
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNextButton:
            return .just(.setIsPresentOnboardingSignUp(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setIsPresentOnboardingSignUp(let bool):
            newState.isPresentOnboardingSignUp = bool
        }
        
        return newState
    }
}
