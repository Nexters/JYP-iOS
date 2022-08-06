//
//  CalenderReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/31.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import ReactorKit

final class CalendarReactor: Reactor {
    enum Action {
        case selectDateAction(Date)
    }

    enum Mutation {
        case dismiss
    }

    struct State {
        var selectedDate: String
        var isDismissed: Bool = false
    }

    var initialState: State
    let service: CalendarServiceProtocol

    init(service: CalendarServiceProtocol, selectedDate: String) {
        initialState = State(selectedDate: selectedDate)
        self.service = service
    }
}

extension CalendarReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectDateAction(date):
            return service.updateSelectedDate(to: date).map { _ in .dismiss }
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
