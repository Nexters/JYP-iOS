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
        case tapPikiHeaderEditButton(IndexPath)
        case tapEmptyPikiPlusButton(IndexPath)
    }
    
    enum Mutation {
        case setSections([JourneyPlanSectionModel])
        case updateSectionItem(IndexPath, JourneyPlanSectionModel.Item)
    }
    
    struct State {
        var sections: [JourneyPlanSectionModel]
    }
    
    let provider = ServiceProvider.shared
    var initialState: State
    
    init() {
        initialState = .init(sections: [])
    }
}

extension JourneyPlanReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .tapPikiHeaderEditButton(indexPath):
            if let reactor = makeReactor(from: indexPath) {
                provider.plannerService.event.onNext(.presentPlannerRoute(reactor))
            }
            return .empty()
        case let .tapEmptyPikiPlusButton(indexPath):
            if let reactor = makeReactor(from: indexPath) {
                provider.plannerService.event.onNext(.presentPlannerRoute(reactor))
            }
            return .empty()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = provider.plannerService.event.withUnretained(self).flatMap { (this, event) -> Observable<Mutation> in
            switch event {
            case let .fetchJourney(journey):
                return Observable.just(Mutation.setSections(this.provider.plannerService.makeSections(from: journey)))
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

    private func makeReactor(from indexPath: IndexPath) -> PlannerRouteReactor? {
        guard let journey = provider.plannerService.journey else { return nil }
        
        let order: Int = indexPath.section - 1
        let date: Date = Date(timeIntervalSince1970: journey.startDate)
        let addedDate: Date = DateManager.addDateComponent(byAdding: .day, value: order, to: date)
        let pikis: [Pik] = journey.pikis[indexPath.section]
        let pikmis: [Pik] = journey.pikmis
        
        return .init(state: .init(order: order, date: addedDate, pikis: pikis, pikmis: pikmis))
    }
}
