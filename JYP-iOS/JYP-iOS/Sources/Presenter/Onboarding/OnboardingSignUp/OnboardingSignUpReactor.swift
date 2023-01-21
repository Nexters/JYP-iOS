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
        case login(authVendor: AuthVendor, token: String, name: String?, profileImagePath: String?)
    }
    
    enum Mutation {
        case setDidLogin(Bool)
    }
    
    struct State {
        var didLogin: Bool = false
    }
    
    let initialState: State
    
    let authService: AuthServiceType
    
    init(authService: AuthServiceType) {
        self.authService = authService
        self.initialState = .init()
    }
}

extension OnboardingSignUpReactor {
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let APIMutation = authService.event.withUnretained(self).flatMap { (_, event) -> Observable<Mutation> in
            switch event {
            case let .apple(response):
                KeychainAccess.set(key: .accessToken, value: response.token)
                
                return .concat([
                    .just(.setDidLogin(true)),
                    .just(.setDidLogin(false))
                ])
                
            case let .kakao(response):
                KeychainAccess.set(key: .accessToken, value: response.token)
                
                return .concat([
                    .just(.setDidLogin(true)),
                    .just(.setDidLogin(false))
                ])
            }
        }
        
        return Observable.merge(APIMutation, mutation)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .login(authVendor, token, name, profileImagePath):
            if let name = name {
                if name.isEmpty == false {
                    KeychainAccess.set(key: .nickname, value: name)
                }
            }
            
            if let profileImagePath = profileImagePath {
                if profileImagePath.isEmpty == false {
                    KeychainAccess.set(key: .profileImagePath, value: profileImagePath)
                }
            }
            
            switch authVendor {
            case .apple:
                authService.apple(token: token)
                
            case .kakao:
                authService.kakao(token: token)
            }
            
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setDidLogin(bool):
            newState.didLogin = bool
        }
        
        return newState
    }
}
