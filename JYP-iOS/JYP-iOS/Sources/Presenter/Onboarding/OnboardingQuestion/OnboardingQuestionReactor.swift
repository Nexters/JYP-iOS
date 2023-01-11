//
//  OnboardingQuestionReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/18.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class OnboardingQuestionReactor: Reactor {
    enum Mode {
        case joruney
        case place
        case plan
    }
    
    enum Action {
        case tapFirstView
        case tapSecondView
        case tapNextButton
    }
    
    enum Mutation {
        case setFirstViewState(OnboardingCardViewState)
        case setSecondViewState(OnboardingCardViewState)
        case setIsActive(Bool)
    }
    
    struct State {
        var stateFirstView: OnboardingCardViewState = .defualt
        var stateSecondView: OnboardingCardViewState = .defualt
        var isActive: Bool = false
    }
    
    let initialState: State
    
    let mode: Mode
    let provider: ServiceProviderType = ServiceProvider.shared
    let onboardingService: OnboardingServiceType
    
    init(mode: Mode, onboardingService: OnboardingServiceType) {
        self.mode = mode
        self.onboardingService = onboardingService
        self.initialState = State()
    }
    
    // MARK: - Setup Reactor
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapFirstView:
            return .concat([
                .just(.setFirstViewState(.active)),
                .just(.setSecondViewState(.inactive)),
                .just(.setIsActive(true))
            ])
            
        case .tapSecondView:
            return .concat([
                .just(.setFirstViewState(.inactive)),
                .just(.setSecondViewState(.active)),
                .just(.setIsActive(true))
            ])
            
        case .tapNextButton:
            if mode == .plan {
                
            }
            return .empty()
        }
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setFirstViewState(state):
            newState.stateFirstView = state
            
        case let .setSecondViewState(state):
            newState.stateSecondView = state
            
        case let .setIsActive(bool):
            newState.isActive = bool
        }
        
        return newState
    }
}
