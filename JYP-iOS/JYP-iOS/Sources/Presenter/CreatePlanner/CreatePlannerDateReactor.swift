//
//  CreatePlannerDateReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/31.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import ReactorKit

final class CreatePlannerDateReactor: Reactor {
    enum Action {
        case startDateAction
        case endDateAction
    }

    enum Mutation {
        case setStartTextFieldFocus(Bool)
        case setEndTextFieldFocus(Bool)
        case updateStartDate(Date)
    }

    struct State {
        var isFocusStartTextField: Bool = false
        var isFocusEndTextField: Bool = false
        var startDate = Date()
    }

    var initialState: State
    let service: CalendarServiceProtocol

    init(service: CalendarServiceProtocol) {
        self.service = service
        initialState = .init()
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

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = service.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .updateStartDate(date):
                return .just(.updateStartDate(date))
            }
        }

        return Observable.merge(mutation, eventMutation)
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
        case let .updateStartDate(date):
            newState.isFocusStartTextField = false
            newState.startDate = date
        }

        return newState
    }

    func makeCalendarReactor() -> CalendarReactor {
        .init(service: service, selectedDate: currentState.startDate)
    }
}
