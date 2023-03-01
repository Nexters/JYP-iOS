//
//  CalenderReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/31.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import ReactorKit

struct CalendarDays {
    var start: Date?
    var end: Date?
}

enum CalendarSelectMode {
    case start
    case end(CalendarDays)
}

final class CalendarReactor: Reactor {
    enum Action {
        case selectDateAction(Date)
    }

    enum Mutation {
        case dismiss
    }

    struct State {
        var selectedDate: Date
        var startDate: Date?
        var endDate: Date?
        var isDismissed: Bool = false
    }

    var initialState: State
    let service: CalendarServiceProtocol
    let mode: CalendarSelectMode

    init(service: CalendarServiceProtocol, selectedDate: Date, mode: CalendarSelectMode) {
        self.service = service
        self.mode = mode

        switch mode {
        case .start:
            initialState = State(selectedDate: selectedDate)
        case let .end(calendarDays):
            initialState = State(selectedDate: selectedDate, startDate: calendarDays.start, endDate: nil)
        }
    }
}

extension CalendarReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectDateAction(date):
            let dateString = DateManager.dateToString(format: "yyyy-MM-dd", date: date)
            let date = DateManager.stringToDate(format: "yyyy-MM-dd", date: dateString)
            
            switch mode {
            case .start:
                return service.updateStartDate(to: date).map { _ in .dismiss }
            case .end:
                return service.updateEndDate(to: date).map { _ in .dismiss }
            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .dismiss:
            newState.isDismissed = true
        }

        return newState
    }
}
