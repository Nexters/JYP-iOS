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
        case login(AuthVendor, String)
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
        case let .login(vendor, token):
            switch vendor {
            case .apple:
                authService.apple(token: token)
                
            case .kakao:
                authService.kakao(token: token)
            }
            
            return .empty()
        }
    }
}
