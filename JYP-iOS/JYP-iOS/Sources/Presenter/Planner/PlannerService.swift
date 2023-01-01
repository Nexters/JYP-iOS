//
//  PlannerService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

enum PlannerEvent {
    case refresh
    case presentTagBottomSheet(TagBottomSheetReactor?)
    case presentPlannerSearchPlace(PlannerSearchPlaceReactor?)
    case presentWeb(WebReactor?)
    case showPlannerRouteScreen(Int)
}

protocol PlannerServiceProtocol {
    var event: PublishSubject<PlannerEvent> { get }
    
    func refresh()
    func presentTagBottomSheet(from reactor: TagBottomSheetReactor)
    func presentPlannerSearchPlace(from reactor: PlannerSearchPlaceReactor)
    func presentWeb(from reactor: WebReactor)
    func showPlannerRouteScreen(order: Int)
}

class PlannerService: PlannerServiceProtocol {
    let event = PublishSubject<PlannerEvent>()
    
    func refresh() {
        event.onNext(.refresh)
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
    
    func showPlannerRouteScreen(order: Int) {
        event.onNext(.showPlannerRouteScreen(order))
    }
}
