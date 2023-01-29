//
//  RemovePlannerBottomSheetReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2023/01/29.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import ReactorKit

final class RemovePlannerBottomSheetReactor: Reactor {
    enum Action {
        case didTapNoButton
        case didTapYesButton
    }

    enum Mutation {
        case dismiss
    }

    struct State {
        let journey: Journey
        var dismiss: Bool = false
    }

    var initialState: State

    private let journeyService: JourneyServiceType

    init(journeyService: JourneyServiceType, journey: Journey) {
        self.journeyService = journeyService
        initialState = .init(journey: journey)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNoButton:
            return .just(.dismiss)
        default: return .empty()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .dismiss:
            newState.dismiss = true
        }
        return newState
    }
}
