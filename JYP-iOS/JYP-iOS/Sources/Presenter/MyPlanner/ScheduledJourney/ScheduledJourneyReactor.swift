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
        let section = ScheduledJourneySectionModel(
            model: (),
            items: Self.makeMockJourneyItem()
        )

        initialState = .init(sections: [section])
    }
}

extension ScheduledJourneyReactor {
    private static func makeMockJourneyItem() -> [JourneyCardItem] {
        [
            .journey(
                .init(
                    journey: .init(
                        id: "1",
                        member: [],
                        name: "name",
                        startDate: 0.0,
                        endDate: 0.0,
                        journeyPlaces: [],
                        tags: [],
                        candidatePlaces: [],
                        themeUrl: .default
                    )
                )
            ),
            .journey(
                .init(
                    journey: .init(
                        id: "1",
                        member: [],
                        name: "name",
                        startDate: 0.0,
                        endDate: 0.0,
                        journeyPlaces: [],
                        tags: [],
                        candidatePlaces: [],
                        themeUrl: .city
                    )
                )
            ),
            .journey(
                .init(
                    journey: .init(
                        id: "1",
                        member: [],
                        name: "name",
                        startDate: 0.0,
                        endDate: 0.0,
                        journeyPlaces: [],
                        tags: [],
                        candidatePlaces: [],
                        themeUrl: .culture
                    )
                )
            )
        ]
    }
}
