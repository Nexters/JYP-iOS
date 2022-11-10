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
        case didTapJoinCodeButton
    }

    enum Mutation {
        case changeActivePlannerJoinButton(Bool)
        case pushMyPlanner(Bool)
    }

    struct State {
        var isActivePlannerJoinButton: Bool = false
        var isPushMyPlannerView: Bool = false
    }

    var initialState: State = .init()

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didChangedTextField(str):
            return .just(.changeActivePlannerJoinButton(!str.isEmpty))
        case .didTapJoinCodeButton:
            return .concat(
                .just(.pushMyPlanner(true)),
                .just(.pushMyPlanner(false))
            )
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .changeActivePlannerJoinButton(isActive):
            newState.isActivePlannerJoinButton = isActive
        case let .pushMyPlanner(isPush):
            newState.isPushMyPlannerView = isPush
        }

        return newState
    }
}
