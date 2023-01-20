//
//  PastJourneyReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/20.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

final class PastJourneyReactor: Reactor {
    enum Action {}
    enum Mutation {
        case updateSectionItem([JourneyCardItem])
    }

    struct State {
        var sections: [PastJourneySectionModel]
        weak var parentView: UIViewController?
    }

    var initialState: State
    private let provider = ServiceProvider.shared.journeyService

    init(parent: UIViewController?) {
        let section = PastJourneySectionModel(
            model: (),
            items: []
        )

        initialState = .init(sections: [section], parentView: parent)
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        provider.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .fetchJourneyList(response):
                let currentTime = DateManager.currentTimeInterval
                let pastJourneys = response
                    .filter { $0.endDate < currentTime }
                guard !pastJourneys.isEmpty
                else { return .just(.updateSectionItem([JourneyCardItem.empty])) }

                let items = pastJourneys
                    .map { JourneyCardItem.journey(.init(journey: $0)) }
                return .just(.updateSectionItem(items))
            default: return .empty()
            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .updateSectionItem(items):
            newState.sections[0].items = items
        }
        return newState
    }
}
