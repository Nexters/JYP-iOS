//
//  CreateProfileBottomSheetReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/01/29.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import ReactorKit

class CreateProfileBottomSheetReactor: Reactor {
    enum Action {
        case refresh
        case tapButton
    }
    
    enum Mutation {
        case setNickname(String)
        case setPersonalityID(PersonalityID)
    }
    
    struct State {
        var nickname: String?
        var personalityID: PersonalityID?
        var isActive: Bool = false
    }
    
    var initialState: State
    
    let onboardingService: OnboardingServiceType
    let userService: UserServiceType
    
    init(onboardingService: OnboardingServiceType,
         userService: UserServiceType) {
        self.onboardingService = onboardingService
        self.userService = userService
        self.initialState = .init()
    }
}

extension CreateProfileBottomSheetReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .concat([
                .just(.setNickname(UserDefaultsAccess.get(key: .nickname) ?? "")),
                .just(.setPersonalityID(PersonalityID.toSelf(title: UserDefaultsAccess.get(key: .personality) ?? "")))
            ])
            
        case .tapButton:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setNickname(nickname):
            newState.nickname = nickname
            
        case let .setPersonalityID(id):
            newState.personalityID = id
        }
        
        return newState
    }
}
