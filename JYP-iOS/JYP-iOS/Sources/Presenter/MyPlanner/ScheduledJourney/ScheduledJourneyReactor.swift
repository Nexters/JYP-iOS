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
//        let section = ScheduledJourneySectionModel(model: (), items: [.empty])

        let journey = Journey(id: "1", member: [], name: "name", startDate: 0.0, endDate: 0.0, journeyPlaces: [], tags: [], candidatePlaces: [], themeUrl: "url")

        let section = ScheduledJourneySectionModel(model: (), items: [.journey(.init(journey: journey)), .journey(.init(journey: journey)), .journey(.init(journey: journey))])

        initialState = .init(sections: [section])
    }
}
