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
    case presentMyPlanner(MyPlannerReactor?)
}

protocol OnboardingServiceProtocol {
    var event: PublishSubject<OnboardingEvent> { get }
    var signupReqeust: SignupRequest { get }
    
    func signup()
    
    func updatePersonalityId(page: Int, index: Int)
    func updateAuthVender(_ authVender: AuthVendor)
    func updateAuthID(_ authID: String)
    func updateProfileImagePath(_ profileImagePath: String)
    func updateName(_ name: String)
}

class OnboardingService: BaseService, OnboardingServiceProtocol {
    let event = PublishSubject<OnboardingEvent>()
    
    var signupReqeust: SignupRequest = SignupRequest(authVendor: .kakao, authID: "", name: "", profileImagePath: "", personalityID: .ME)
    var personalityIdInts: [Int] = [0, 0, 0]
    
    func signup() {
        provider.userService.signup(request: signupReqeust)
            .compactMap { $0.data }
            .withUnretained(self)
            .bind { this, _ in
                let reactor = MyPlannerReactor()
                
                this.event.onNext(.presentMyPlanner(reactor))
                this.event.onNext(.presentMyPlanner(nil))
            }
            .disposed(by: disposeBag)
    }
    
    func updatePersonalityId(page: Int, index: Int) {
        personalityIdInts[page] = index
        signupReqeust.personalityID = PersonalityId.intsToPersonalityId(ints: personalityIdInts)
    }
    
    func updateAuthVender(_ authVender: AuthVendor) {
        signupReqeust.authVendor = authVender
    }
    
    func updateAuthID(_ authID: String) {
        signupReqeust.authID = authID
    }
    
    func updateName(_ name: String) {
        signupReqeust.name = name
    }
    
    func updateProfileImagePath(_ profileImagePath: String) {
        signupReqeust.profileImagePath = profileImagePath
    }
}
