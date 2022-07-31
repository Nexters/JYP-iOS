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
        case setSelectedDate(Date)
        case dismiss
    }

    struct State {
        var selectedDate: Date
        var isDismissed: Bool = false
    }

    var initialState: State

    init() {
        initialState = State(selectedDate: Date())
    }
}

extension CalendarReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectDateAction(date):
            return Observable.concat(
                Observable.just(Mutation.setSelectedDate(date)),
                Observable.just(Mutation.dismiss)
            )
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setSelectedDate(date):
            print(date)
            newState.selectedDate = date
        case .dismiss:
            newState.isDismissed = true
        }

        return newState
    }
}
