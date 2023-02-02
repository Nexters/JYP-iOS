//
//  MyPlannerReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/16.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

final class MyPlannerReactor: Reactor {
    enum Action {
        case fetchJourneyList
        case didTapScheduledJourneyMenu
        case didTapPastJourneyMenu
        case didTapAddPlannerButton
    }

    enum Mutation {
        case setUser(User)
        case showScheduledJourney(Bool)
        case showPastJourney(Bool)
        case pushCreatePlannerView(Bool)
        case pushNewPlannerView(String)
    }

    struct State {
        var user: User?
        var journeys: [Journey] = []
        var pastJourneys: [Journey] = []
        var isSelectedSchduledJourneyView: Bool = true
        var isSelectedPastJourneyView: Bool = false
        var isPushCreatePlannerView: Bool = false
        var didCreatedPlannerID: String?
    }

    private let journeyService: JourneyServiceType
    private let userService: UserServiceType
    let initialState = State()

    init(journeyService: JourneyServiceType, userService: UserServiceType) {
        self.journeyService = journeyService
        self.userService = userService
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchJourneyList:
            journeyService.fetchJornenys()
            return .empty()
        case .didTapScheduledJourneyMenu:
            return .concat(
                .just(.showScheduledJourney(true)),
                .just(.showPastJourney(false))
            )
        case .didTapPastJourneyMenu:
            return .concat(
                .just(.showScheduledJourney(false)),
                .just(.showPastJourney(true))
            )
        case .didTapAddPlannerButton:
            return .concat(
                .just(.pushCreatePlannerView(true)),
                .just(.pushCreatePlannerView(false))
            )
        }
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let journeyEvent = journeyService.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .didFinishCreatePlanner(id):
                return .just(.pushNewPlannerView(id))
            default: return .empty()
            }
        }
        
        let userEvent = userService.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .fetchMe(user), let .fetchUser(user), let .createUser(user):
                return .just(.setUser(user))
            default: return .empty()
            }
        }

        return Observable.merge(mutation, journeyEvent, userEvent)
    }

    func transform(action: Observable<Action>) -> Observable<Action> {
        let newEvent = journeyService.event.flatMap { event -> Observable<Action> in
            switch event {
            case .requestRefreshJourneys:
                return .just(.fetchJourneyList)
            default: return .empty()
            }
        }

        return Observable.merge(action, newEvent)
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setUser(user):
            newState.user = user
        case let .showScheduledJourney(isSelected):
            newState.isSelectedSchduledJourneyView = isSelected
        case let .showPastJourney(isSelected):
            newState.isSelectedPastJourneyView = isSelected
        case let .pushCreatePlannerView(isPush):
            newState.isPushCreatePlannerView = isPush
        case let .pushNewPlannerView(id):
            newState.didCreatedPlannerID = id
        }

        return newState
    }
}
