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
        case tapAppleLoginButton
        case tapKakaoLoginButton
        case login(String)
    }
    
    enum Mutation {
        case updateIsOpenKakaoLogin(Bool)
        case updateIsOpenAppleLogin(Bool)
    }
    
    struct State {
        var isOpenKakaoLogin: Bool = false
        var isOpenAppleLogin: Bool = false
    }
    
    let initialState: State
    
    let onboardingService: OnboardingServiceType
    let authService: AuthServiceType
    
    init(onboardingService: OnboardingServiceType,
         authService: AuthServiceType) {
        self.onboardingService = onboardingService
        self.authService = authService
        self.initialState = .init()
    }
}

extension OnboardingSignUpReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapKakaoLoginButton:
            return didTapKakaoLoginButtonMutation()
            
        case .didTapAppleLoginButton:
            return didTapAppleLoginButtonMutation()
            
        case let .didLogin(authVendor, authId, name, profileImagePath):
            return didLoginMutation(authVendor: authVendor, authID: authId, name: name, profileImagePath: profileImagePath)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateIsOpenKakaoLogin(bool):
            newState.isOpenKakaoLogin = bool
            
        case let .updateIsOpenAppleLogin(bool):
            newState.isOpenAppleLogin = bool
            
        case let .updateOnboardingQuestionReactor(reactor):
            newState.onboardingQuestionReactor = reactor
        }
        
        return newState
    }
    
    private func didTapKakaoLoginButtonMutation() -> Observable<Mutation> {
        return .concat([
            .just(.updateIsOpenKakaoLogin(true)),
            .just(.updateIsOpenKakaoLogin(false))
        ])
    }
    
    private func didTapAppleLoginButtonMutation() -> Observable<Mutation> {
        return .concat([
            .just(.updateIsOpenAppleLogin(true)),
            .just(.updateIsOpenAppleLogin(false))
        ])
    }
    
    private func didLoginMutation(authVendor: AuthVendor, authID: String, name: String, profileImagePath: String) -> Observable<Mutation> {
        provider.onboaringService.updateAuthVender(authVender: authVendor)
        provider.onboaringService.updateAuthID(authID: authID)
        provider.onboaringService.updateName(name: name)
        provider.onboaringService.updateProfileImagePath(profileImagePath: profileImagePath)
        
        return .concat([
            .just(.updateOnboardingQuestionReactor(OnboardingQuestionReactor(mode: .joruney))),
            .just(.updateOnboardingQuestionReactor(nil))
        ])
    }
}
