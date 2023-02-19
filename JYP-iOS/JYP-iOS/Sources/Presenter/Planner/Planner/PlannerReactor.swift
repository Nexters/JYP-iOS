//
//  PlannerReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

class PlannerReactor: Reactor {
    enum ViewType {
        case journeyPlan
        case discussion
    }
    
    enum Action {
        case refresh(UIViewController)
        case showView(ViewType)
        case tapPlusButton
    }

    enum Mutation {
        case setJourney(Journey)
        case setViewType(ViewType)
    }

    struct State {
        let id: String
        var journey: Journey?
        var viewType: ViewType = .journeyPlan
    }

    var initialState: State
    
    private let journeyService: JourneyServiceType
    
    init(id: String, journeyService: JourneyServiceType) {
        self.journeyService = journeyService
        self.initialState = .init(id: id)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh: return .empty()
        case let .showView(type): return .just(.setViewType(type))
        case .tapPlusButton: return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setJourney(journey): newState.journey = journey
        case let .setViewType(type): newState.viewType = type
        }

        return newState
    }

//    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
//        let APIMutation = provider.journeyService.event.withUnretained(self).flatMap { (this, event) -> Observable<Mutation> in
//            switch event {
//            case let .fetchJourney(journey):
//                return .just(.setJourney(journey))
//
//            case .createPikmiLike, .deletePikmiLike:
//                this.provider.plannerService.refresh()
//                return .empty()
//
//            default:
//                return .empty()
//            }
//        }
//
//        let eventMutation = provider.plannerService.event.withUnretained(self).flatMap { (this, event) -> Observable<Mutation> in
//            switch event {
//            case .refresh:
//                this.provider.journeyService.fetchJorney(id: this.id)
//                return .empty()
//
//            case let .presentTagBottomSheet(reactor):
//                return .just(.setTagBottomSheetReactor(reactor))
//
//            case let .presentPlannerSearchPlace(reactor):
//                return .just(.setPlannerSearchPlaceReactor(reactor))
//
//            case let .presentWeb(reactor):
//                return .just(.setWebReactor(reactor))
//
//            case let .showPlannerRouteScreen(order):
//                return .concat([
//                    .just(.setOrderPlannerRouteScreen(order)),
//                    .just(.setOrderPlannerRouteScreen(nil))
//                ])
//            }
//        }
//
//        return Observable.merge(mutation, APIMutation, eventMutation)
//    }
}
