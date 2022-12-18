//
//  ScheduledJourneyReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/16.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

final class ScheduledJourneyReactor: Reactor {
    enum Action {}
    enum Mutation {
        case updateSectionItem([JourneyCardItem])
    }

    struct State {
        var sections: [ScheduledJourneySectionModel]
        weak var parentView: UIViewController?
    }

    var initialState: State
    private let provider = ServiceProvider.shared.journeyService

    init(parent: UIViewController?) {
        let section = ScheduledJourneySectionModel(
            model: (),
            items: []
        )

        initialState = .init(sections: [section], parentView: parent)
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        provider.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .fetchJourneyList(response):
                guard !response.isEmpty
                else { return .just(.updateSectionItem([JourneyCardItem.empty])) }

                let currentTime = DateManager.currentTimeInterval
                let items = response
                    .filter { $0.startDate > currentTime }
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
