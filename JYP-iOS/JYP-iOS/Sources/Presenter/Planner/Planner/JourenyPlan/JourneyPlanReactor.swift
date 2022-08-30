//
//  JourneyPlanReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/18.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class JourneyPlanReactor: Reactor {
    enum Action {
        case tapEmptyPikiPlusButton(IndexPath)
    }
    
    enum Mutation {
        case setSections([JourneyPlanSectionModel])
        case updateSectionItem(IndexPath, JourneyPlanSectionModel.Item)
    }
    
    struct State {
        var sections: [JourneyPlanSectionModel]
    }
    
    let provider = ServiceProvider.shared.plannerService
    var initialState: State
    
    init() {
        initialState = .init(sections: [])
    }
}

extension JourneyPlanReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        let state = self.currentState
        
        switch action {
        case let .tapEmptyPikiPlusButton(indexPath):
            guard case let .emptyPiki(reactor) = state.sections[indexPath.section].items[indexPath.row] else { return .empty() }
            provider.event.onNext(.presentPlannerRoute(makeReactor(from: reactor)))
            return .empty()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.event.withUnretained(self).flatMap { (this, event) -> Observable<Mutation> in
            switch event {
            case let .fetchJourney(journey):
                return Observable.just(Mutation.setSections(this.provider.makeSections(from: journey)))
            default:
                return .empty()
            }
        }
        
        return Observable.merge(mutation, eventMutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setSections(sections):
            newState.sections = sections
        case let .updateSectionItem(indexPath, item):
            newState.sections[indexPath.section].items[indexPath.row] = item
        }
        
        return newState
    }
    
    private func makeReactor(from reactor: EmptyPikiCollectionViewCellReactor) -> PlannerRouteReactor {
        return .init(state: .init(order: reactor.currentState.order, date: reactor.currentState.date))
    }
}
