//
//  OnboardingService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/21.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import RxSwift

enum OnboardingEvent {
    case updateSignupRequest(SignupRequest)
}

protocol OnboardingServiceProtocol {
    var event: PublishSubject<OnboardingEvent> { get }
    var signupReqeust: SignupRequest { get }
    
    func updatePersonalityId(page: Int, index: Int)
    func updateAuthVender(_ authVender: AuthVendor)
    func updateAuthID(_ authID: String)
    func updateProfileImagePath(_ profileImagePath: String)
    func updateName(_ name: String)
}

class OnboardingService: OnboardingServiceProtocol {
    let event = PublishSubject<OnboardingEvent>()
    
    var signupReqeust: SignupRequest = SignupRequest(authVendor: .kakao, authID: "", name: "", profileImagePath: "", personalityID: .ME)
    var personalityIdInts: [Int] = [0, 0, 0]
    
    func updatePersonalityId(page: Int, index: Int) {
        personalityIdInts[page] = index
        signupReqeust.personalityID = PersonalityId.intsToPersonalityId(ints: personalityIdInts)
        event.onNext(.updateSignupRequest(signupReqeust))
    }
    
    func updateAuthVender(_ authVender: AuthVendor) {
        signupReqeust.authVendor = authVender
        event.onNext(.updateSignupRequest(signupReqeust))
    }
    
    func updateAuthID(_ authID: String) {
        signupReqeust.authID = authID
        event.onNext(.updateSignupRequest(signupReqeust))
    }
    
    func updateName(_ name: String) {
        signupReqeust.name = name
        event.onNext(.updateSignupRequest(signupReqeust))
    }
    
    func updateProfileImagePath(_ profileImagePath: String) {
        signupReqeust.profileImagePath = profileImagePath
        event.onNext(.updateSignupRequest(signupReqeust))
    }
}
