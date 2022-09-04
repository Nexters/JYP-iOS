//
//  SelectPlannerCoverBottomSheetReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/09/04.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

final class SelectPlannerCoverBottomSheetReactor: Reactor {
    enum Action {}
    enum Mutation {}
    
    struct State {
        let sections: [SelectPlannerCoverSectionModel]
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
}
