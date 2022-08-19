//
//  PastJourneyReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/20.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

final class PastJourneyReactor: Reactor {
    enum Action {}
    enum Mutation {}

    struct State {
        var sections: [PastJourneySectionModel]
    }

    var initialState: State

    init() {
        let section = PastJourneySectionModel(
            model: (),
            items: Self.makeMockJourneyItem()
        )

        initialState = .init(sections: [section])
    }
}

extension PastJourneyReactor {
    private static func makeMockJourneyItem() -> [JourneyCardItem] {
        [.empty]
    }
}
