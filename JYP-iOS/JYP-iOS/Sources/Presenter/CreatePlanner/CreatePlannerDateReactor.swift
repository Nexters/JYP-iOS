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
        case updateEndDate(Date)
        case presentCalendar(Bool)
    }

    struct State {
        var isFocusStartTextField: Bool = false
        var isFocusEndTextField: Bool = false
        var isPresent: Bool = false
        var startDate = ""
        var endDate = ""
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
            return Observable.concat(
                Observable.just(Mutation.presentCalendar(true)),
                Observable.just(Mutation.setStartTextFieldFocus(true)),
                Observable.just(Mutation.presentCalendar(false))
            )
        case .endDateAction:
            return Observable.concat(
                Observable.just(Mutation.presentCalendar(true)),
                Observable.just(Mutation.setEndTextFieldFocus(true)),
                Observable.just(Mutation.presentCalendar(false))
            )
        }
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = service.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .updateStartDate(date):
                let isStartDate = self.currentState.isFocusStartTextField
                return isStartDate ? .just(.updateStartDate(date)) : .just(.updateEndDate(date))
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
            newState.startDate = DateManager.dateToString(date: date)
        case let .updateEndDate(date):
            newState.isFocusEndTextField = false
            newState.endDate = DateManager.dateToString(date: date)
        case let .presentCalendar(flag):
            newState.isPresent = flag
        }

        return newState
    }

    func makeCalendarReactor() -> CalendarReactor {
        let selectedDate = currentState.isFocusEndTextField ? currentState.startDate : currentState.endDate

        return .init(service: service, selectedDate: selectedDate)
    }
}
