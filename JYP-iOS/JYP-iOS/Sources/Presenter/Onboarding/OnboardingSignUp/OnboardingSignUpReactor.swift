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
        case didTapKakaoLoginButton
        case didTapAppleLoginButton
        case didLogin
    }
    
    enum Mutation {
        case setIsOpenKakaoLogin(Bool)
        case setIsOpenAppleLogin(Bool)
        case setIsPresentOnboardingWhatIsTrip(Bool)
    }
    
    struct State {
        var isOpenKakaoLogin: Bool = false
        var isOpenAppleLogin: Bool = false
        var isPresentOnboardingWhatIsTrip: Bool = false
    }
    
    let initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    // MARK: - Setup Mutate
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapKakaoLoginButton:
            return .just(.setIsOpenKakaoLogin(true))
        case .didTapAppleLoginButton:
            return .just(.setIsOpenAppleLogin(true))
        case .didLogin:
            return .just(.setIsPresentOnboardingWhatIsTrip(true))
        }
    }
    
    // MARK: - Setup Reduce
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setIsOpenKakaoLogin(let bool):
            newState.isOpenKakaoLogin = bool
        case .setIsOpenAppleLogin(let bool):
            newState.isOpenAppleLogin = bool
        case .setIsPresentOnboardingWhatIsTrip(let bool):
            newState.isPresentOnboardingWhatIsTrip = bool
        }
        
        return newState
    }
}

extension OnboardingSignUpReactor {
    func getOnboardingWhatIsTripReactor() -> OnboardingQuestionJourneyReactor {
        return OnboardingQuestionJourneyReactor(initialState: .init())
    }
}
