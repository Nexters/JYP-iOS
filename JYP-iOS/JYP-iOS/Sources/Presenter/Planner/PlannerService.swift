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
    case fetchJourney(Journey)
    case presentTagBottomSheet(TagBottomSheetReactor?)
    case presentPlannerSearchPlace(PlannerSearchPlaceReactor?)
    case presentWeb(WebReactor?)
    case presentPlannerRoute(PlannerRouteReactor?)
}

protocol PlannerServiceProtocol {
    var event: PublishSubject<PlannerEvent> { get }
    var journey: Journey? { get }
    
    func updateJourney(to journey: Journey)
    
    func presentTagBottomSheet(from reactor: TagBottomSheetReactor)
    func presentPlannerSearchPlace(from reactor: PlannerSearchPlaceReactor)
    func presentWeb(from reactor: WebReactor)
    func presentPlannerRoute(from reactor: PlannerRouteReactor)
}

class PlannerService: PlannerServiceProtocol {
    let event = PublishSubject<PlannerEvent>()
    var journey: Journey?
    
    func updateJourney(to journey: Journey) {
        self.journey = journey
        event.onNext(.fetchJourney(journey))
    }
    
    func presentTagBottomSheet(from reactor: TagBottomSheetReactor) {
        event.onNext(.presentTagBottomSheet(reactor))
        event.onNext(.presentTagBottomSheet(nil))
    }
    
    func presentPlannerSearchPlace(from reactor: PlannerSearchPlaceReactor) {
        event.onNext(.presentPlannerSearchPlace(reactor))
        event.onNext(.presentPlannerSearchPlace(nil))
    }
    
    func presentWeb(from reactor: WebReactor) {
        event.onNext(.presentWeb(reactor))
        event.onNext(.presentWeb(nil))
    }
    
    func presentPlannerRoute(from reactor: PlannerRouteReactor) {
        event.onNext(.presentPlannerRoute(reactor))
        event.onNext(.presentPlannerRoute(nil))
    }
}
