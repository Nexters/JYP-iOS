//
//  PlannerService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import RxSwift

enum PlannerEvent {
    case fetchJourney(NewJourney)
}

protocol PlannerServiceProtocol {
    var event: PublishSubject<PlannerEvent> { get }

    func updateJourney(to journey: NewJourney) -> Observable<NewJourney>
}

class PlannerService: PlannerServiceProtocol {
    let event = PublishSubject<PlannerEvent>()
    var journey: NewJourney?
    
    func updateJourney(to journey: NewJourney) -> Observable<NewJourney> {
        self.journey = journey
        event.onNext(.fetchJourney(journey))
        
        return .just(journey)
    }
}
