//
//  ScheduledJourneyReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/16.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

final class ScheduledJourneyReactor: Reactor {
    enum Action {}
    enum Mutation {}

    struct State {
        var sections: [ScheduledJourneySectionModel]
    }

    var initialState: State

    init() {
        let section = ScheduledJourneySectionModel(model: (), items: [.empty])

        let journey = ScheduledJourneySectionModel(model: (), items: [.journey(.init())])

        initialState = .init(sections: [section, journey])
    }
}
