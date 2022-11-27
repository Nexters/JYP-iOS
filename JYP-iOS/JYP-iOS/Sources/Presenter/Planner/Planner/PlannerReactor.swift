//
//  PlannerReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import ReactorKit

class PlannerReactor: Reactor {
    enum Action {
        case refresh
        case showDiscussion
        case showJourneyPlan
        case invite
    }
    
    enum Mutation {
        case setJourney(Journey)
        case setIsShowDiscussion(Bool)
        case setIsShowJourneyPlan(Bool)
        case setPlannerInviteReactor(PlannerInviteReactor?)
        case setTagBottomSheetReactor(TagBottomSheetReactor?)
        case setPlannerSearchPlaceReactor(PlannerSearchPlaceReactor?)
        case setPlannerRouteReactor(PlannerRouteReactor?)
        case setWebReactor(WebReactor?)
    }
    
    struct State {
        var id: String
        var journey: Journey?
        var isShowDiscussion: Bool = true
        var isShowJourneyPlan: Bool = false
        var plannerInviteReactor: PlannerInviteReactor?
        var tagBottomSheetReactor: TagBottomSheetReactor?
        var plannerSearchPlaceReactor: PlannerSearchPlaceReactor?
        var plannerRouteReactor: PlannerRouteReactor?
        var webReactor: WebReactor?
    }
    
    let provider = ServiceProvider.shared
    
    var initialState: State
    
    init(id: String) {
        self.initialState = .init(id: id)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            provider.plannerService.refresh()
            return .empty()
            
        case .showDiscussion:
            return .concat([
                .just(.setIsShowDiscussion(true)),
                .just(.setIsShowJourneyPlan(false))
            ])
            
        case .showJourneyPlan:
            return .concat([
                .just(.setIsShowDiscussion(false)),
                .just(.setIsShowJourneyPlan(true))
            ])
            
        case .invite:
            return .concat([
                .just(.setPlannerInviteReactor(makeReactor())),
                .just(.setPlannerInviteReactor(nil))
            ])
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let APIMutation = provider.journeyService.event.withUnretained(self).flatMap { (this, event) -> Observable<Mutation> in
            switch event {
            case let .fetchJourney(journey):
                return .just(.setJourney(journey))
                
            default:
                return .empty()
            }
        }
        
        let eventMutation = provider.plannerService.event.withUnretained(self).flatMap { (this, event) -> Observable<Mutation> in
            switch event {
            case .refresh:
                this.provider.journeyService.fetchJorney(id: this.currentState.id)
                return .empty()
                
            case let .presentTagBottomSheet(reactor):
                return .just(.setTagBottomSheetReactor(reactor))
                
            case let .presentPlannerSearchPlace(reactor):
                return .just(.setPlannerSearchPlaceReactor(reactor))
                
            case let .presentPlannerRoute(reactor):
                return .concat([
                    .just(.setPlannerRouteReactor(reactor)),
                    .just(.setPlannerRouteReactor(nil))
                ])
                
            case let .presentWeb(reactor):
                return .just(.setWebReactor(reactor))
            }
        }
        
        return Observable.merge(mutation, APIMutation, eventMutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setJourney(journey):
            newState.journey = journey
            
        case let .setIsShowDiscussion(bool):
            newState.isShowDiscussion = bool
            
        case let .setIsShowJourneyPlan(bool):
            newState.isShowJourneyPlan = bool
            
        case let .setPlannerInviteReactor(reactor):
            newState.plannerInviteReactor = reactor
            
        case let .setTagBottomSheetReactor(reactor):
            newState.tagBottomSheetReactor = reactor
            
        case let .setPlannerSearchPlaceReactor(reactor):
            newState.plannerSearchPlaceReactor = reactor
            
        case let .setPlannerRouteReactor(reactor):
            newState.plannerRouteReactor = reactor
            
        case let .setWebReactor(reactor):
            newState.webReactor = reactor
        }
        
        return newState
    }
    
    private func makeReactor() -> PlannerInviteReactor {
        return .init(id: currentState.id)
    }
}
