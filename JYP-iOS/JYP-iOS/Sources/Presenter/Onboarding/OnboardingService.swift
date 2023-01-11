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

protocol OnboardingServiceType {
    var event: PublishSubject<OnboardingEvent> { get }
    
    func updateIsQuestion(mode: OnboardingQuestionReactor.Mode, value: Bool)
}

class OnboardingService: BaseService, OnboardingServiceType {
    let event = PublishSubject<OnboardingEvent>()
    
    private var isJourneyQuestion: Bool = false
    private var isPlaceQuestion: Bool = false
    private var isPlanQuestion: Bool = false
    
    func updateIsQuestion(mode: OnboardingQuestionReactor.Mode, value: Bool) {
        switch mode {
        case .joruney:
            isJourneyQuestion = value
        case .place:
            isPlaceQuestion = value
        case .plan:
            isPlanQuestion = value
        }
    }
}
