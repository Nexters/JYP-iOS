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
    let userService: UserServiceType
    let onboardingService: OnboardingServiceType
    
    init(mode: Mode,
         onboardingService: OnboardingServiceType,
         userService: UserServiceType) {
        self.mode = mode
        self.onboardingService = onboardingService
        self.userService = userService
        self.initialState = State()
    }
    
    // MARK: - Setup Reactor
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapFirstView:
            onboardingService.updateIsQuestion(mode: mode, value: true)
            
            return .concat([
                .just(.setFirstViewState(.active)),
                .just(.setSecondViewState(.inactive)),
                .just(.setIsActive(true))
            ])
            
        case .tapSecondView:
            onboardingService.updateIsQuestion(mode: mode, value: false)
            
            return .concat([
                .just(.setFirstViewState(.inactive)),
                .just(.setSecondViewState(.active)),
                .just(.setIsActive(true))
            ])
            
//        case .tapNextButton:
//            switch mode {
//            case .joruney, .place:
//                return .empty()
//                
//            case .plan:
//                let name = KeychainAccess.get(key: .nickname) ?? ""
//                let profileImagePath = KeychainAccess.get(key: .profileImagePath) ?? ""
//                
//                userService.createUser(request: .init(name: name, profileImagePath: profileImagePath, personalityId: onboardingService.getPersonalityID()))
//                return .empty()
//            }
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
