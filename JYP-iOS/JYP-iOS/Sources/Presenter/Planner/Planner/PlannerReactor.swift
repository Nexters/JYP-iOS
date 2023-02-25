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
    
    enum Action {
        case refresh
        case showView(ViewType)
        case tapPlusButton
        case selectDiscussionCell(IndexPath, DiscussionItem)
        case selectJourneyPlanCell(IndexPath, JourneyPlanItem)
    }
    
    enum Mutation {
        case setJourney(Journey)
        case setViewType(ViewType)
    }
    
    struct State {
        let id: String
        var journey: Journey?
        var viewType: ViewType = .journeyPlan
    }
    
    var initialState: State
    
    let journeyService: JourneyServiceType
    
    init(id: String, journeyService: JourneyServiceType) {
        self.journeyService = journeyService
        self.initialState = .init(id: id)
    }
}

extension PlannerReactor {
    func bind(action: JourneyPlanReactor.Action) {
        switch action {
        case let .tapEditButton(indexPath): break
        case let .tapPlusButton(indexPath): break
        default: break
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return journeyService.fetchJorney(id: initialState.id).map {
                .setJourney($0)
            }
            
        case let .showView(type):
            return .just(.setViewType(type))
            
        case let .selectDiscussionCell(indexPath, item):
            return .empty()
            
        case let .selectJourneyPlanCell(indexPath, item):
            return .empty()
            
        case .tapPlusButton:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case let .setJourney(journey):
            newState.journey = journey
            
        case let .setViewType(type):
            newState.viewType = type
        }

        return newState
    }
}
