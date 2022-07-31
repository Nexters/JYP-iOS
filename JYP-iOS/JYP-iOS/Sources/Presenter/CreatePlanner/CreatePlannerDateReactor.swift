//
//  CreatePlannerDateReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/31.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

final class CreatePlannerDateReactor: Reactor {
    enum Action {
        case startDateAction
        case endDateAction
    }

    struct State {
        var isFocusStartTextField: Bool
        var isFocusEndTextField: Bool
    }

    enum Mutation {
        case setStartTextFieldFocus(Bool)
        case setEndTextFieldFocus(Bool)
    }

    var initialState: State

    init() {
        initialState = State(isFocusStartTextField: true, isFocusEndTextField: false)
    }
}

extension CreatePlannerDateReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startDateAction:
            return Observable.just(Mutation.setStartTextFieldFocus(true))
        case .endDateAction:
            return Observable.just(Mutation.setEndTextFieldFocus(true))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setStartTextFieldFocus(isFocus):
            newState.isFocusStartTextField = isFocus
            newState.isFocusEndTextField = !isFocus
        case let .setEndTextFieldFocus(isFocus):
            newState.isFocusStartTextField = !isFocus
            newState.isFocusEndTextField = isFocus
        }

        return newState
    }
}
