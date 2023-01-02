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
        case didTapJoinCodeButton(String)
    }

    enum Mutation {
        case changePlannerCode(String)
        case changeActivePlannerJoinButton(Bool)
        case pushMyPlanner(String?)
        case validateJoin(EmptyModel)
    }

    struct State {
        var plannerCode: String?
        var isActivePlannerJoinButton: Bool = false
        var isPushMyPlannerView: String?
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
        case let .didTapJoinCodeButton(code):
            return provider.joinPlanner(journeyId: code)
                .map { .validateJoin($0) }
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
        case let .pushMyPlanner(id):
            newState.isPushMyPlannerView = id
        case let .validateJoin(model):
            switch model.code {
            case "20000":
                newState.isPushMyPlannerView = state.plannerCode
            default:
                newState.guideLabel = "잘못된 참여 코드에요"
                newState.isActivePlannerJoinButton = false
            }
        }

        return newState
    }
}
