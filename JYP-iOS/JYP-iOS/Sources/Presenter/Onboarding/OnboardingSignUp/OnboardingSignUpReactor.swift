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
    }
    
    struct State {
    }
    
    let initialState: State
    
    let authService: AuthServiceType
    
    init(authService: AuthServiceType) {
        self.authService = authService
        self.initialState = .init()
    }
}

extension OnboardingSignUpReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .login(authVendor, token, name, profileImagePath):
            if let name = name {
                if name.isEmpty == false {
                    try? KeychainAccess.set(key: .nickname, value: name)
                }
            }
            
            if let profileImagePath = profileImagePath {
                if profileImagePath.isEmpty == false {
                    try? KeychainAccess.set(key: .profileImagePath, value: profileImagePath)
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
}
