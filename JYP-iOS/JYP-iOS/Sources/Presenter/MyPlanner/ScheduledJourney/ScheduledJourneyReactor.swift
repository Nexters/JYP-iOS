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
                        name: "강릉 여행기",
                        startDate: 0.0,
                        endDate: 0.0,
                        themePath: .default,
                        users: [.init(id: "", nickname: "", profileImagePath: "", personality: .ME), .init(id: "", nickname: "", profileImagePath: "", personality: .ME), .init(id: "", nickname: "", profileImagePath: "", personality: .ME)],
                        tags: [],
                        pikmis: [],
                        pikidays: []
                    )
                )
            ),
            .journey(
                .init(
                    journey: .init(
                        id: "1",
                        name: "서촌 나들이",
                        startDate: 0.0,
                        endDate: 0.0,
                        themePath: .city,
                        users: [.init(id: "", nickname: "", profileImagePath: "", personality: .ME), .init(id: "", nickname: "", profileImagePath: "", personality: .ME)],
                        tags: [],
                        pikmis: [],
                        pikidays: []
                    )
                )
            ),
            .journey(
                .init(
                    journey: .init(
                        id: "1",
                        name: "경주 빵지순례 🙏🏼",
                        startDate: 0.0,
                        endDate: 0.0,
                        themePath: .culture,
                        users: [.init(id: "1", nickname: "", profileImagePath: "", personality: .ME), .init(id: "", nickname: "", profileImagePath: "", personality: .FW), .init(id: "", nickname: "", profileImagePath: "", personality: .ME), .init(id: "", nickname: "", profileImagePath: "", personality: .PE), .init(id: "", nickname: "", profileImagePath: "", personality: .RT), .init(id: "", nickname: "", profileImagePath: "", personality: .RT)],
                        tags: [],
                        pikmis: [],
                        pikidays: []
                    )
                )
            ),
            .journey(
                .init(
                    journey: .init(
                        id: "1",
                        name: "여수 2박 3일",
                        startDate: 0.0,
                        endDate: 0.0,
                        themePath: .sea,
                        users: [.init(id: "", nickname: "", profileImagePath: "", personality: .ME), .init(id: "", nickname: "", profileImagePath: "", personality: .PE), .init(id: "", nickname: "", profileImagePath: "", personality: .ME), .init(id: "", nickname: "", profileImagePath: "", personality: .ME)],
                        tags: [],
                        pikmis: [],
                        pikidays: []
                    )
                )
            ),
            .journey(
                .init(
                    journey: .init(
                        id: "1",
                        name: "한라산 🏔 정복",
                        startDate: 0.0,
                        endDate: 0.0,
                        themePath: .mountain,
                        users: [.init(id: "", nickname: "", profileImagePath: "", personality: .PE), .init(id: "", nickname: "", profileImagePath: "", personality: .PE), .init(id: "", nickname: "", profileImagePath: "", personality: .PE), .init(id: "", nickname: "", profileImagePath: "", personality: .PE), .init(id: "", nickname: "", profileImagePath: "", personality: .ME), .init(id: "", nickname: "", profileImagePath: "", personality: .ME), .init(id: "", nickname: "", profileImagePath: "", personality: .ME)],
                        tags: [],
                        pikmis: [],
                        pikidays: []
                    )
                )
            )
        ]
    }
}
