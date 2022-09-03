//
//  CreatePlannerNameReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/09/03.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

final class CreatePlannerNameReactor: Reactor {
    private static let MAX_NAME_LENGTH = 10

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
        case presentCoverImageBottomSheet
    }

    struct State {
        var validation: PlannerNameTextFieldInputState = .invalid
        var guideText: String = PlannerNameTextFieldInputState.valid.guideText
    }

    var initialState: State = .init()

    // MARK: - Mutate

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNextButton:
            return .empty()
        case let .inputTextField(text):
            let isValid = (text.count <= Self.MAX_NAME_LENGTH) && !text.isEmpty

            let mutation: Observable<Mutation> = isValid ? .just(.changeValidation(.valid)) : .just(.changeValidation(.invalid))
            return mutation
        }
    }

    // MARK: - Reduce

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .changeValidation(validation):
            newState.validation = validation
            newState.guideText = validation.guideText
        case .presentCoverImageBottomSheet:
            newState.guideText = " "
        }

        return newState
    }
}
