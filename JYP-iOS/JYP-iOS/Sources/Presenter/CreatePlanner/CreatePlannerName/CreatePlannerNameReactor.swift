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
        case emptyCharacters
        case exceededCharacters

        var guideText: String {
            switch self {
            case .valid: return ""
            case .emptyCharacters: return ""
            case .exceededCharacters: return "입력 가능한 글자를 초과했어요"
            }
        }
    }

    enum Action {
        case inputTextField(String)
        case didTapNextButton
        case didTapNameTag(PlannerNameTag)
    }

    enum Mutation {
        case changeValidation(PlannerNameTextFieldInputState)
        case presentCoverImageBottomSheet(Bool)
        case changeTextField(String)
    }

    struct State {
        var validation: PlannerNameTextFieldInputState = .emptyCharacters
        var guideText: String = PlannerNameTextFieldInputState.valid.guideText
        var textFieldText: String = ""
        var isPresentCoverBottomSheet: Bool = false
        var journey: Journey = .init(
            id: "",
            name: "",
            startDate: 0,
            endDate: 0,
            themePath: .default,
            users: []
        )
    }

    var initialState: State = .init()
    private let provider = ServiceProvider.shared.journeyService

    // MARK: - Mutate

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapNextButton:
            return .concat(
                .just(.presentCoverImageBottomSheet(true)),
                .just(.presentCoverImageBottomSheet(false))
            )
        case let .inputTextField(text):
            guard !text.isEmpty else { return .just(.changeValidation(.emptyCharacters)) }
            let isValid = text.count <= Self.MAX_NAME_LENGTH

            let mutation: Observable<Mutation> = isValid ?
                .just(.changeValidation(.valid)) : .just(.changeValidation(.exceededCharacters))
            return mutation
        case let .didTapNameTag(tag):
            return .just(.changeTextField(tag.rawValue))
        }
    }

    // MARK: - Reduce

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .changeValidation(validation):
            newState.validation = validation
            newState.guideText = validation.guideText
        case let .changeTextField(text):
            newState.textFieldText = text
            newState.journey.name = text
        case let .presentCoverImageBottomSheet(flag):
            newState.isPresentCoverBottomSheet = flag
        }

        return newState
    }
}
