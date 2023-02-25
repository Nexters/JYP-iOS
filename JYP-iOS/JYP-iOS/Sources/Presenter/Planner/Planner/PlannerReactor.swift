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
    }
    
    enum Action {
        case refresh
        case showView(ViewType)
        case tapPlusButton
        case selectDiscussionCell(IndexPath, DiscussionItem)
        case selectJourneyPlanCell(IndexPath, JourneyPlanItem)
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
        case let .selectCell(_, item):
            switch item {
            case let .tag(reactor):
                self.action.onNext(.pushNextScreen(.tagBottomSheet(tag: reactor.currentState)))
            default: break
            }
        case .tapCellCreateButton, .tapPlusButton:
            self.action.onNext(.pushNextScreen(.plannerSearchPlace(id: initialState.id)))
        case let .tapCellLikeButton(_, state):
            if state.isSelected {
                journeyService.deletePikmiLike(journeyId: currentState.id, pikmiId: state.pik.id)
            } else {
                journeyService.createPikmiLike(journeyId: currentState.id, pikmiId: state.pik.id)
            }
            self.action.onNext(.refresh)
        default: break
        }
    }
    
    func bind(action: JourneyPlanReactor.Action) {
        switch action {
        case let .tapEditButton(indexPath): break
        case let .tapPlusButton(indexPath): break
        case let .selectCell(indexPath, item): break
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
        case let .selectDiscussionCell(indexPath, item): return .empty()
        case let .selectJourneyPlanCell(indexPath, item): return .empty()
        case .tapPlusButton: return .empty()
            
        case let .pushNextScreen(type):
            return .concat([
                .just(.setNextScreenType(type)),
                .just(.setNextScreenType(nil))
            ])
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
