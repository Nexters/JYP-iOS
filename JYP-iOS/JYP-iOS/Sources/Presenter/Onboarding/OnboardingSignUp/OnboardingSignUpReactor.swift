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
        case didLogin(authVendor: AuthVendor, authId: String, name: String, profileImagePath: String)
    }
    
    enum Mutation {
        case updateIsOpenKakaoLogin(Bool)
        case updateIsOpenAppleLogin(Bool)
        case updateOnboardingQuestionReactor(OnboardingQuestionReactor?)
    }
    
    struct State {
        var isOpenKakaoLogin: Bool = false
        var isOpenAppleLogin: Bool = false
        var onboardingQuestionReactor: OnboardingQuestionReactor?
    }
    
    let initialState: State
    let service: OnboardingServiceProtocol = ServiceProvider.shared.onboaringService
    
    init() {
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
            return didLoginMutation(authVendor: authVendor, authId: authId, name: name, profileImagePath: profileImagePath)
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
    
    private func didLoginMutation(authVendor: AuthVendor, authId: String, name: String, profileImagePath: String) -> Observable<Mutation> {
        service.updateAuthVender(authVender: authVendor)
        service.updateAuthID(authId: authId)
        service.updateName(name: name)
        service.updateProfileImagePath(profileImagePath: profileImagePath)
        
        return .concat([
            .just(.updateOnboardingQuestionReactor(OnboardingQuestionReactor(mode: .joruney))),
            .just(.updateOnboardingQuestionReactor(nil))
        ])
    }
}
