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
    }

    enum Mutation {
        case changeSelection(IndexPath)
    }

    struct State {
        let sections: [SelectPlannerCoverSectionModel]
        var selectedIndexPath: IndexPath = .init(row: 0, section: 0)
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
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .changeSelection(indexPath):
            newState.selectedIndexPath = indexPath
        }

        return newState
    }
}
