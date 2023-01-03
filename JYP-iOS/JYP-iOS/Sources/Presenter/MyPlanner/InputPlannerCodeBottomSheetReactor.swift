//
//  InputPlannerCodeBottomSheetReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/10/16.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

final class InputPlannerCodeBottomSheetReactor: Reactor {
    enum Action {
        case didChangedTextField(String)
    }

    enum Mutation {
        case changePlannerCode(String)
        case changeActivePlannerJoinButton(Bool)
    }

    struct State {
        var plannerCode: String?
        var isActivePlannerJoinButton: Bool = false
        var guideLabel: String?
    }

    var initialState: State = .init()
    private let provider = ServiceProvider.shared.journeyService

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didChangedTextField(str):
            return .concat([
                .just(.changeActivePlannerJoinButton(!str.isEmpty)),
                .just(.changePlannerCode(str))
            ])
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .changePlannerCode(code):
            newState.plannerCode = code
        case let .changeActivePlannerJoinButton(isActive):
            newState.guideLabel = nil
            newState.isActivePlannerJoinButton = isActive
        }

        return newState
    }
}
