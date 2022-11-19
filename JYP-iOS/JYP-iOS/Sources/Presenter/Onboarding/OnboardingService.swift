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
    
    func createUser()
    
    func updatePersonalityIdData(index: Int, int: Int)
    func updateAuthVender(authVender: AuthVendor)
    func updateAuthID(authId: String)
    func updateName(name: String)
    func updateProfileImagePath(profileImagePath: String)
}

class OnboardingService: BaseService, OnboardingServiceProtocol {
    let event = PublishSubject<OnboardingEvent>()
    
    private var authVendor: AuthVendor = .kakao
    private var authId: String = ""
    private var name: String = ""
    private var profileImagePath: String = ""
    private var personalityId: PersonalityId = .ME
    private var personalityIdData: [Int] = [0, 0, 0]
    
    func createUser() {
        let request: CreateUserRequest = .init(authVendor: authVendor, authID: authId, name: name, profileImagePath: profileImagePath, personalityID: personalityId)
        
        provider.userService.createUser(request: request)
            .compactMap { $0.data }
            .withUnretained(self)
            .bind { this, _ in
                let reactor: MyPlannerReactor = .init()
                this.event.onNext(.presentMyPlanner(reactor))
                this.event.onNext(.presentMyPlanner(nil))
            }
            .disposed(by: disposeBag)
    }
    
    func updatePersonalityIdData(index: Int, int: Int) {
        self.personalityIdData[index] = int
        self.updatePersonalityId(personalityIdData: personalityIdData)
    }
    
    func updateAuthVender(authVender: AuthVendor) {
        self.authVendor = authVender
    }
    
    func updateAuthID(authId: String) {
        self.authId = authId
    }
    
    func updateName(name: String) {
        self.name = name
    }
    
    func updateProfileImagePath(profileImagePath: String) {
        self.profileImagePath = profileImagePath
    }
    
    private func updatePersonalityId(personalityIdData: [Int]) {
        self.personalityId = PersonalityId.intsToPersonalityId(data: personalityIdData)
    }
}
