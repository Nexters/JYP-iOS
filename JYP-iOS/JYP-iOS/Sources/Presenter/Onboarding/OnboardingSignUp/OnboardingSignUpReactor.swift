//
//  OnboardingSignUpReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class OnboardingSignUpReactor: Reactor {
    enum NextScreenType {
        case onboardingQuestionJourney
        case tabBar
    }
    
    enum Action {
        case login(authVendor: AuthVendor, token: String, name: String?, profileImagePath: String?)
    }
    
    enum Mutation {
        case setNextScreenType(NextScreenType?)
    }
    
    struct State {
        var nextScreenType: NextScreenType?
    }
    
    let initialState: State
    
    let authService: AuthServiceType
    let userService: UserServiceType
    
    init(authService: AuthServiceType,
         userService: UserServiceType) {
        self.authService = authService
        self.userService = userService
        self.initialState = .init()
    }
}

extension OnboardingSignUpReactor {
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let authEventMutation = authService.event.withUnretained(self).flatMap { (this, event) -> Observable<Mutation> in
            switch event {
            case .apple, .kakao:
                this.userService.fetchMe()
            }
            return .empty()
        }
        
        let userEventMutation = userService.event.withUnretained(self).flatMap { (_, event) -> Observable<Mutation> in
            switch event {
            case .fetchMe:
                return .concat([
                    .just(.setNextScreenType(.tabBar)),
                    .just(.setNextScreenType(nil))
                ])
                
            case .error:
                return .concat([
                    .just(.setNextScreenType(.onboardingQuestionJourney)),
                    .just(.setNextScreenType(nil))
                ])
                
            default:
                return .empty()
            }
        }
        
        return Observable.merge(authEventMutation, userEventMutation, mutation)
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
        case let .setNextScreenType(type):
            newState.nextScreenType = type
        }
        
        return newState
    }
}
