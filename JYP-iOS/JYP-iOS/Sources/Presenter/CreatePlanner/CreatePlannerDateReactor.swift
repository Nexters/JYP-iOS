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
        case didTapStartDateTextField
        case didTapEndDateTextField
    }

    enum Mutation {
        case setStartTextFieldFocus(Bool)
        case setEndTextFieldFocus(Bool)
        case updateStartDate(Date)
        case updateEndDate(Date)
        case presentCalendar(Bool)
    }

    struct State {
        var isFocusStartTextField: Bool = false
        var isFocusEndTextField: Bool = false
        var isPresent: Bool = false
        var startDate = ""
        var endDate = ""
        var isHiddenSubmitButton: Bool = true
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
        let openCalendar: Observable<Mutation> = .just(.presentCalendar(true))
        let closeCalendar: Observable<Mutation> = .just(.presentCalendar(false))

        switch action {
        case .didTapStartDateTextField:
            let setStartDateTextFieldFocus: Observable<Mutation> = .just(.setStartTextFieldFocus(true))
            let setEndDateTextFieldFocus: Observable<Mutation> = .just(.setEndTextFieldFocus(false))

            return .concat(setStartDateTextFieldFocus, setEndDateTextFieldFocus, openCalendar, closeCalendar)
        case .didTapEndDateTextField:
            let setStartDateTextFieldFocus: Observable<Mutation> = .just(.setStartTextFieldFocus(false))
            let setEndDateTextFieldFocus: Observable<Mutation> = .just(.setEndTextFieldFocus(true))

            return .concat(setStartDateTextFieldFocus, setEndDateTextFieldFocus, openCalendar, closeCalendar)
        }
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = service.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .updateStartDate(date):
                return .just(.updateStartDate(date))
            case let .updateEndDate(date):
                return .just(.updateEndDate(date))
            }
        }

        return Observable.merge(mutation, eventMutation)
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setStartTextFieldFocus(isFocus):
            newState.isFocusStartTextField = isFocus
        case let .setEndTextFieldFocus(isFocus):
            newState.isFocusEndTextField = isFocus
        case let .updateStartDate(date):
            newState.isFocusStartTextField = false
            newState.startDate = DateManager.dateToString(date: date)
        case let .updateEndDate(date):
            newState.isFocusEndTextField = false
            newState.isHiddenSubmitButton = false
            newState.endDate = DateManager.dateToString(date: date)
        case let .presentCalendar(flag):
            newState.isPresent = flag
        }

        return newState
    }

    func makeCalendarReactor() -> CalendarReactor {
        let mode: CalendarSelectMode = currentState.isFocusStartTextField ? .start : .end
        let selectedDate = currentState.isFocusStartTextField ? currentState.startDate : currentState.endDate

        return .init(service: service, selectedDate: selectedDate, mode: mode)
    }
}
