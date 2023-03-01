//
//  PlannerReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

class PlannerReactor: Reactor {
    enum ViewType {
        case journeyPlan
        case discussion
    }
    
    enum NextScreenType {
        case tagBottomSheet(tag: Tag)
        case plannerSearchPlace(id: String)
        case plannerRoute(index: Int, journey: Journey)
        case web(url: String)
    }
    
    enum Action {
        case refresh
        case showView(ViewType)
        case tapPlusButton
        case pushNextScreen(NextScreenType)
    }
    
    enum Mutation {
        case setJourney(Journey)
        case setViewType(ViewType)
        case setNextScreenType(NextScreenType?)
    }
    
    struct State {
        let id: String
        var journey: Journey?
        var viewType: ViewType = .discussion
        var nextScreenType: NextScreenType?
    }
    
    var initialState: State
    
    let journeyService: JourneyServiceType
    
    init(id: String, journeyService: JourneyServiceType) {
        self.journeyService = journeyService
        self.initialState = .init(id: id)
    }
}

extension PlannerReactor {
    func bind(action: DiscussionReactor.Action) {
        switch action {
        case let .fetch:
            self.action.onNext(.refresh)
        case let .selectCell(_, item):
            switch item {
            case let .tag(reactor):
                self.action.onNext(.pushNextScreen(.tagBottomSheet(tag: reactor.currentState)))
            default: break
            }
        case let .tapCellLikeButton(_, state):
            if state.isSelected {
                journeyService.deletePikmiLike(journeyId: currentState.id, pikmiId: state.pik.id)
            } else {
                journeyService.createPikmiLike(journeyId: currentState.id, pikmiId: state.pik.id)
            }
        case .tapCellCreateButton, .tapPlusButton:
            self.action.onNext(.pushNextScreen(.plannerSearchPlace(id: initialState.id)))
        case let .tapCellInfoButton(_, state):
            self.action.onNext(.pushNextScreen(.web(url: state.pik.link)))
        default: break
        }
    }
    
    func bind(action: JourneyPlanReactor.Action) {
        guard let journey = currentState.journey else { return }
        
        switch action {
        case let .tapEditButton(_, state):
            self.action.onNext(.pushNextScreen(.plannerRoute(index: state.index, journey: journey)))
        case let .tapPlusButton(_, state):
            self.action.onNext(.pushNextScreen(.plannerRoute(index: state.index, journey: journey)))
        default: break
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return journeyService.fetchJorney(id: initialState.id).map {
                .setJourney($0)
            }
            
        case let .showView(type): return .just(.setViewType(type))
            
        case let .pushNextScreen(type):
            return .concat([
                .just(.setNextScreenType(type)),
                .just(.setNextScreenType(nil))
            ])
            
        case .tapPlusButton: return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setJourney(journey): newState.journey = journey
        case let .setViewType(type): newState.viewType = type
        case let .setNextScreenType(type): newState.nextScreenType = type
        }

        return newState
    }
}
