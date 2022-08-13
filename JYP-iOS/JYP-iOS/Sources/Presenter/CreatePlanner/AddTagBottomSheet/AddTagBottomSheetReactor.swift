//
//  AddTagBottomSheetReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/13.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

enum TagTextFieldInputState {
    case valid
    case invalid

    var guideText: String {
        switch self {
        case .valid: return "6글자 이하 가능"
        case .invalid: return "6글자까지 입력 가능해요"
        }
    }

    var textColor: UIColor {
        switch self {
        case .valid: return JYPIOSAsset.subBlack.color
        case .invalid: return JYPIOSAsset.mainPink.color
        }
    }
}

final class AddTagBottomSheetReactor: Reactor {
    private static let MAX_TAG_LENGTH = 6

    enum Action {
        case inputTextField(String)
        case saveTag(String)
        case dismiss
    }

    enum Mutation {
        case changeValidation(TagTextFieldInputState)
        case dismiss
    }

    struct State {
        var section: TagSection
        var valid: TagTextFieldInputState = .invalid
        var guideText: String = TagTextFieldInputState.valid.guideText
        var guideTextColor: UIColor = TagTextFieldInputState.valid.textColor
        var dismiss: Bool = false
    }

    let initialState: State
    let provider: ServiceProviderType

    init(provider: ServiceProviderType, section: TagSection) {
        self.provider = provider
        initialState = .init(section: section)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .inputTextField(text):
            let isValid = (text.count <= Self.MAX_TAG_LENGTH) && !text.isEmpty

            let mutation: Observable<Mutation> = isValid ? .just(.changeValidation(.valid)) : .just(.changeValidation(.invalid))
            return mutation
        case let .saveTag(tagName):
            return provider.tagService.saveTag(name: tagName, section: currentState.section).map { _ in .dismiss }
        case .dismiss:
            return .just(.dismiss)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState: State = state

        switch mutation {
        case let .changeValidation(state):
            newState.valid = state
            newState.guideText = state.guideText
            newState.guideTextColor = state.textColor
        case .dismiss:
            newState.dismiss = true
        }

        return newState
    }
}
