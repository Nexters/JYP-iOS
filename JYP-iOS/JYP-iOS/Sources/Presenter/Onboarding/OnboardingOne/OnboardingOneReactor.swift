//
//  OnboardingLikingReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/31.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class OnboardingOneReactor: Reactor {   
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
    
    init() {
        self.initialState = State()
    }
    
    // MARK: - Setup Reactor
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNextButton:
            return .just(.setIsPresentOnboardingPlace(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setIsPresentOnboardingPlace(let bool):
            newState.isPresentOnboardingPlace = bool
        }
        
        return newState
    }
}
