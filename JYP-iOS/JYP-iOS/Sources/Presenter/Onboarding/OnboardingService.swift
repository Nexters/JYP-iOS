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
    
    func updatePersonalityIDData(index: Int, int: Int)
    func updateAuthVender(authVender: AuthVendor)
    func updateAuthID(authID: String)
    func updateName(name: String)
    func updateProfileImagePath(profileImagePath: String)
}

class OnboardingService: BaseService, OnboardingServiceProtocol {
    let event = PublishSubject<OnboardingEvent>()
    
    private var authVendor: AuthVendor = .kakao
    private var authID: String = ""
    private var name: String = ""
    private var profileImagePath: String = ""
    private var personalityID: PersonalityID = .ME
    private var personalityIDData: [Int] = [0, 0, 0]
    
    func createUser() {
        let request: CreateUserRequest = .init(name: name, profileImagePath: profileImagePath, personalityID: personalityID)
        
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
    
    func updatePersonalityIDData(index: Int, int: Int) {
        self.personalityIDData[index] = int
        self.updatePersonalityID(personalityIDData: personalityIDData)
    }
    
    func updateAuthVender(authVender: AuthVendor) {
        self.authVendor = authVender
        
        try? provider.keychainService.setAuthVendor(authVender)
    }
    
    func updateAuthID(authID: String) {
        self.authID = authID
        
        if authID.isEmpty == false {
            try? provider.keychainService.setAccessToken(authID)
        }
    }
    
    func updateName(name: String) {
        self.name = name
        
        if name.isEmpty == false {
            try? provider.keychainService.setName(name)
        }
    }
    
    func updateProfileImagePath(profileImagePath: String) {
        self.profileImagePath = profileImagePath
        
        if !profileImagePath.isEmpty {
            try? provider.keychainService.setImagePath(profileImagePath)
        }
    }
    
    private func updatePersonalityID(personalityIDData: [Int]) {
        self.personalityID = PersonalityID.intsToPersonalityID(data: personalityIDData)
    }
}
