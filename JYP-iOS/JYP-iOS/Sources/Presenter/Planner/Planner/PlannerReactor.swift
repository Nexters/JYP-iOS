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
        case fetchJourney
        case updateIsShowDiscussion(Bool)
        case updateIsShowJourneyPlan(Bool)
        case updatePlannerInviteReactor(PlannerInviteReactor?)
        case updateTagBottomSheetReactor(TagBottomSheetReactor?)
        case updatePlannerSearchPlaceReactor(PlannerSearchPlaceReactor?)
        case updatePlannerRouteReactor(PlannerRouteReactor?)
        case updateWebReactor(WebReactor?)
    }
    
    struct State {
        var journeyId: String
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
    
    init(journeyId: String) {
        self.initialState = .init(journeyId: journeyId)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return mutateRefresh()
        case .showDiscussion:
            return mutateShowDiscussion()
        case .showJourneyPlan:
            return mutateShowJourneyPlan()
        case .invite:
            return mutateInvite()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.plannerService.event.flatMap { (event) -> Observable<Mutation> in
            switch event {
            case .fetchJourney: return .empty()
            case let .presentTagBottomSheet(reactor):
                return .just(.updateTagBottomSheetReactor(reactor))
            case let .presentPlannerSearchPlace(reactor):
                return .just(.updatePlannerSearchPlaceReactor(reactor))
            case let .presentPlannerRoute(reactor):
                return .concat([
                    .just(.updatePlannerRouteReactor(reactor)),
                    .just(.updatePlannerRouteReactor(nil))
                ])
            case let .presentWeb(reactor):
                return .just(.updateWebReactor(reactor))
            }
        }
        
        return Observable.merge(mutation, eventMutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .fetchJourney:
            break
        case let .updateIsShowDiscussion(bool):
            newState.isShowDiscussion = bool
        case let .updateIsShowJourneyPlan(bool):
            newState.isShowJourneyPlan = bool
        case let .updatePlannerInviteReactor(reactor):
            newState.plannerInviteReactor = reactor
        case let .updateTagBottomSheetReactor(reactor):
            newState.tagBottomSheetReactor = reactor
        case let .updatePlannerSearchPlaceReactor(reactor):
            newState.plannerSearchPlaceReactor = reactor
        case let .updatePlannerRouteReactor(reactor):
            newState.plannerRouteReactor = reactor
        case let .updateWebReactor(reactor):
            newState.webReactor = reactor
        }
        
        return newState
    }
    
    private func mutateRefresh() -> Observable<Mutation> {
        return provider.journeyService.fetchJorney(journeyId: "0")
            .withUnretained(self)
            .map { this, response in
                this.provider.plannerService.updateJourney(to: response.data)
                return .fetchJourney
            }
    }
    
    private func mutateShowDiscussion() -> Observable<Mutation> {
        return .concat([
            .just(.updateIsShowDiscussion(true)),
            .just(.updateIsShowJourneyPlan(false))
        ])
    }
    
    private func mutateShowJourneyPlan() -> Observable<Mutation> {
        return .concat([
            .just(.updateIsShowDiscussion(false)),
            .just(.updateIsShowJourneyPlan(true))
        ])
    }
    
    private func mutateInvite() -> Observable<Mutation> {
        return .concat([
            .just(.updatePlannerInviteReactor(makeReactor())),
            .just(.updatePlannerInviteReactor(nil))
        ])
    }
    
    private func makeReactor() -> PlannerInviteReactor {
        return .init(id: currentState.journeyId)
    }
}
