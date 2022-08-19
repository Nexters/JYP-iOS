//
//  JourneyCardCollectionViewCellReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/16.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

final class JourneyCardCollectionViewCellReactor: Reactor {
    enum Action {}

    enum Mutation {}

    struct State {
        var journey: Journey
    }

    let initialState: State

    init(journey: Journey) {
        initialState = .init(journey: journey)
    }
}
