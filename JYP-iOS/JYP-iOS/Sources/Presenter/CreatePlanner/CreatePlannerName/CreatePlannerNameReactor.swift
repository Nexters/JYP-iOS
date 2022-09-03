//
//  CreatePlannerNameReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/09/03.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

final class CreatePlannerNameReactor: Reactor {
    // MARK: - Sub Types

    enum PlannerNameTextFieldInputState {
        case valid
        case invalid

        var guideText: String {
            switch self {
            case .valid: return ""
            case .invalid: return "입력 가능한 글자를 초과했어요"
            }
        }
    }

    enum Action {
        case inputTextField(String)
        case didTapNextButton
    }

    enum Mutation {
        case changeValidation(PlannerNameTextFieldInputState)
    }

    struct State {
        var valid: PlannerNameTextFieldInputState = .invalid
        var guideText: String = PlannerNameTextFieldInputState.valid.guideText
    }

    var initialState: State = .init()

    // MARK: - Mutate

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNextButton:
            return .empty()
        case let .inputTextField(string):
            return .empty()
        }
    }

    // MARK: - Reduce

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .changeValidation(validation):
            newState.valid = validation
        }

        return newState
    }
}
