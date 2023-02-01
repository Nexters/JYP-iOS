//
//  CreateProfileBottomSheetReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/01/29.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import ReactorKit

class CreateProfileBottomSheetReactor: Reactor {
    enum ProfileType {
        case `default`
        case my
    }
    
    enum Action {
        case tapProfileBox
        case tapDefaultProfileBox
        case tapButton
    }
    
    enum Mutation {
        case setProfileType(ProfileType)
        case setDismiss(Bool)
    }
    
    struct State {
        var profileType: ProfileType?
        var dimiss: Bool = false
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
        case .tapProfileBox:
            return .just(.setProfileType(.my))
            
        case .tapDefaultProfileBox:
            return .just(.setProfileType(.default))
            
        case .tapButton:
            let nickname = UserDefaultsAccess.get(key: .nickname) ?? ""
            var profileImagePath: String
            let personalityId = PersonalityID.toSelf(title: UserDefaultsAccess.get(key: .personality) ?? "")
            
            switch currentState.profileType {
            case .my:
                profileImagePath = UserDefaultsAccess.get(key: .profileImagePath) ?? ""
                
            default:
                profileImagePath = personalityId.defaultImagePath
            }
            
            userService.createUser(request: .init(name: nickname,
                                                  profileImagePath: profileImagePath,
                                                  personalityId: personalityId))
            return .empty()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let userEventMutation = userService.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case .createUser:
                return .concat([
                    .just(.setDismiss(true)),
                    .just(.setDismiss(false))
                ])
                
            default:
                return .empty()
            }
        }
        
        return Observable.merge(userEventMutation, mutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setProfileType(type):
            newState.profileType = type
            
        case let .setDismiss(bool):
            newState.dimiss = bool
        }
        
        return newState
    }
}
