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
        case didTapScheduledJourneyMenu
        case didTapPastJourneyMenu
    }

    enum Mutation {
        case showScheduledJourney(Bool)
        case showPastJourney(Bool)
    }

    struct State {
        var isSelectedSchduledJourneyView: Bool = true
        var isSelectedPastJourneyView: Bool = false
    }

    let initialState = State()

    init() {}

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
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
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .showScheduledJourney(isSelected):
            newState.isSelectedSchduledJourneyView = isSelected
        case let .showPastJourney(isSelected):
            newState.isSelectedPastJourneyView = isSelected
        }

        return newState
    }
}
