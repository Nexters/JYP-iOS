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
    }
    
    enum Mutation {
        case fetchJourney
        case showDiscussion
        case showJourneyPlan
        case updatePlannerRouteReactor(PlannerRouteReactor?)
    }
    
    struct State {
        var pik: Pik?
        var isShowDiscussion: Bool = true
        var isShowJourneyPlan: Bool = false
        var plannerRouteReactor: PlannerRouteReactor?
    }
    
    let provider = ServiceProvider.shared
    var initialState: State
    
    init() {
        initialState = .init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return provider.journeyService.fetchJorney(id: 0)
                .withUnretained(self)
                .map { this, journey in
                    this.provider.plannerService.updateJourney(to: journey)
                    return .fetchJourney
                }
        case .showDiscussion:
            return .just(.showDiscussion)
        case .showJourneyPlan:
            return .just(.showJourneyPlan)
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.plannerService.event.flatMap { (event) -> Observable<Mutation> in
            switch event {
            case .fetchJourney: return .empty()
            case let .presentPlannerRoute(reactor):
                return .concat([
                    .just(.updatePlannerRouteReactor(reactor)),
                    .just(.updatePlannerRouteReactor(nil))
                ])
            }
        }
        
        return Observable.merge(mutation, eventMutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .fetchJourney:
            break
        case .showDiscussion:
            newState.isShowDiscussion = true
            newState.isShowJourneyPlan = false
        case .showJourneyPlan:
            newState.isShowDiscussion = false
            newState.isShowJourneyPlan = true
        case let .updatePlannerRouteReactor(reactor):
            newState.plannerRouteReactor = reactor
        }
        
        return newState
    }
}
