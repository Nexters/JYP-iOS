//
//  SelectPlannerCoverBottomSheetReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/09/04.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import ReactorKit

final class SelectPlannerCoverBottomSheetReactor: Reactor {
    enum Action {
        case selectTheme(IndexPath, PlannerCoverItem)
        case didTapSubmitButton
    }

    enum Mutation {
        case changeSelection(IndexPath, SelectPlannerCoverCellReactor)
        case pushCalendarView(Bool)
    }

    struct State {
        var journey: Journey
        let sections: [SelectPlannerCoverSectionModel]
        var selectedIndexPath: IndexPath = .init(row: 0, section: 0)
        var isPushCalendarView: Bool = false
    }

    var initialState: State
    
    init(journey: Journey) {
        let section = SelectPlannerCoverSectionModel(
            model: (),
            items: ThemeType.allCases
                .map {
                    PlannerCoverItem.theme(.init(theme: $0))
                }
        )

        initialState = .init(journey: journey, sections: [section])
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectTheme(indexPath, item):
            guard case let PlannerCoverItem.theme(reactor) = item
            else { return .empty() }
            return .just(.changeSelection(indexPath, reactor))
        case .didTapSubmitButton:
            return .concat(
                .just(.pushCalendarView(true)),
                .just(.pushCalendarView(false))
            )
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .changeSelection(indexPath, reactor):
            newState.selectedIndexPath = indexPath
            newState.journey.themePath = reactor.currentState.theme
        case let .pushCalendarView(isPush):
            newState.isPushCalendarView = isPush
        }

        return newState
    }
}
