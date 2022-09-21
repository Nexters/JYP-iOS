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
    case updatePersonalityId(PersonalityId)
}

protocol OnboardingServiceProtocol {
    var event: PublishSubject<OnboardingEvent> { get }
    var personalityId: PersonalityId { get }
    
    func updatePersonalityId(page: Int, index: Int)
}

class OnboardingService: OnboardingServiceProtocol {
    let event = PublishSubject<OnboardingEvent>()
    var personalityId: PersonalityId = .ME
    var personalityIdInts: [Int] = [0, 0, 0]
    
    func updatePersonalityId(page: Int, index: Int) {
        personalityIdInts[page] = index
        personalityId = PersonalityId.intsToPersonalityId(ints: personalityIdInts)
        event.onNext(.updatePersonalityId(personalityId))
    }
}
