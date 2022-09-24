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
        case didLogin(authVendor: AuthVendor, authID: String, name: String, profileImagePath: String)
    }
    
    enum Mutation {
        case setIsOpenKakaoLogin(Bool)
        case setIsOpenAppleLogin(Bool)
        case updateOnboardingQuestionReactor(OnboardingQuestionReactor?)
    }
    
    struct State {
        var isOpenKakaoLogin: Bool = false
        var isOpenAppleLogin: Bool = false
        var onboardingQuestionReactor: OnboardingQuestionReactor?
    }
    
    let initialState: State
    let service: OnboardingServiceProtocol = ServiceProvider.shared.onboaringService
    
    init(initialState: State) {
        self.initialState = initialState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapKakaoLoginButton:
            return .just(.setIsOpenKakaoLogin(true))
        case .didTapAppleLoginButton:
            return .just(.setIsOpenAppleLogin(true))
        case let .didLogin(authVendor, authID, name, profileImagePath):
            return mutateDidLogin(authVendor: authVendor, authID: authID, name: name, profileImagePath: profileImagePath)
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
        case let .updateOnboardingQuestionReactor(reactor):
            newState.onboardingQuestionReactor = reactor
        }
        
        return newState
    }
    
    private func mutateDidTapKakaoLoginButton() -> Observable<Mutation> {
        return .empty()
    }
    
    private func mutateDidLogin(authVendor: AuthVendor, authID: String, name: String, profileImagePath: String) -> Observable<Mutation> {
        service.updateAuthVender(authVendor)
        service.updateAuthID(authID)
        service.updateName(name)
        service.updateProfileImagePath(profileImagePath)
        
        return .concat([
            .just(.updateOnboardingQuestionReactor(OnboardingQuestionReactor(mode: .joruney))),
            .just(.updateOnboardingQuestionReactor(nil))
        ])
    }
}
