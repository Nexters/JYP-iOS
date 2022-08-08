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
        case setJourneyDays(String)
        case presentCalendar(Bool)
    }

    struct State {
        var isFocusStartTextField: Bool = false
        var isFocusEndTextField: Bool = false
        var isPresent: Bool = false
        var startDate: String = ""
        var endDate: String = ""
        var journeyDays: String = ""
        var isHiddenJourneyDaysButton: Bool = true
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
                return .concat(
                    .just(.updateEndDate(date)),
                    .just(.setJourneyDays(self.service.calcJourneyDays()))
                )
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
        case let .setJourneyDays(days):
            newState.journeyDays = days
            newState.isHiddenJourneyDaysButton = false
        }

        return newState
    }

    func makeCalendarReactor() -> CalendarReactor {
        let startDate = DateManager.stringToDate(date: currentState.startDate)
        let endDate = DateManager.stringToDate(date: currentState.endDate)

        let days = CalendarDays(start: startDate, end: endDate)
        let mode: CalendarSelectMode = currentState.isFocusStartTextField ? .start : .end(days)
        let selectedDate = currentState.isFocusStartTextField ? startDate : endDate

        return .init(service: service, selectedDate: selectedDate, mode: mode)
    }
}
