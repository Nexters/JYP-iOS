//
//  MyPlannerReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/16.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

final class MyPlannerReactor: Reactor {
    enum Action {
        case fetchJourneyList
        case didTapScheduledJourneyMenu
        case didTapPastJourneyMenu
        case didTapAddPlannerButton
    }

    enum Mutation {
        case showScheduledJourney(Bool)
        case showPastJourney(Bool)
        case pushCreatePlannerView(Bool)
        case pushNewPlannerView(String)
    }

    struct State {
        var journeys: [Journey] = []
        var pastJourneys: [Journey] = []
        var isSelectedSchduledJourneyView: Bool = true
        var isSelectedPastJourneyView: Bool = false
        var isPushCreatePlannerView: Bool = false
        var didCreatedPlannerID: String?
    }

    private let provider = ServiceProvider.shared.journeyService
    let initialState = State()

    init() {}

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchJourneyList:
            provider.fetchJornenys()
            return .empty()
        case .didTapScheduledJourneyMenu:
            return .concat(
                .just(.showScheduledJourney(true)),
                .just(.showPastJourney(false))
            )
        case .didTapPastJourneyMenu:
            return .concat(
                .just(.showScheduledJourney(false)),
                .just(.showPastJourney(true))
            )
        case .didTapAddPlannerButton:
            return .concat(
                .just(.pushCreatePlannerView(true)),
                .just(.pushCreatePlannerView(false))
            )
        }
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let newEvent = provider.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .didFinishCreatePlanner(id):
                return .just(.pushNewPlannerView(id))
            default: return .empty()
            }
        }

        return Observable.merge(mutation, newEvent)
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .showScheduledJourney(isSelected):
            newState.isSelectedSchduledJourneyView = isSelected
        case let .showPastJourney(isSelected):
            newState.isSelectedPastJourneyView = isSelected
        case let .pushCreatePlannerView(isPush):
            newState.isPushCreatePlannerView = isPush
        case let .pushNewPlannerView(id):
            newState.didCreatedPlannerID = id
        }

        return newState
    }
}
