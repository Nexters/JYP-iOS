//
//  SelectPlannerCoverReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/09/04.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

final class SelectPlannerCoverCellReactor: Reactor {
    enum Action {}
    enum Mutation {}

    struct State {
        var theme: ThemeType
    }

    let initialState: State

    init(theme: ThemeType) {
        initialState = .init(theme: theme)
    }
}
