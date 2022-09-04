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
        case selectTheme(IndexPath)
        case didTapSubmitButton
    }

    enum Mutation {
        case changeSelection(IndexPath)
        case pushCalendarView
    }

    struct State {
        let sections: [SelectPlannerCoverSectionModel]
        var selectedIndexPath: IndexPath = .init(row: 0, section: 0)
        var isPushCalendarView: Bool = false
    }

    var initialState: State

    init() {
        let section = SelectPlannerCoverSectionModel(
            model: (),
            items: ThemeType.allCases
                .map {
                    PlannerCoverItem.theme(.init(theme: $0))
                }
        )

        initialState = .init(sections: [section])
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectTheme(indexPath):
            return .just(.changeSelection(indexPath))
        case .didTapSubmitButton:
            return .just(.pushCalendarView)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .changeSelection(indexPath):
            newState.selectedIndexPath = indexPath
        case .pushCalendarView:
            newState.isPushCalendarView = true
        }

        return newState
    }
}
