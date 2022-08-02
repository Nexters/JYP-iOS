//
//  OnboardingSignUpReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class OnboardingSignUpReactor: Reactor {
    enum Action {
        case didTapNextButton
    }
    
    enum Mutation {
        case setIsPresentOnboardingPlace(Bool)
    }
    
    struct State {
        var isPresentOnboardingPlace: Bool = false
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    // MARK: - Setup Mutate
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNextButton:
            return .just(.setIsPresentOnboardingPlace(true))
        }
    }
    
    // MARK: - Setup Reduce
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setIsPresentOnboardingPlace(let bool):
            newState.isPresentOnboardingPlace = bool
        }
        
        return newState
    }
}

