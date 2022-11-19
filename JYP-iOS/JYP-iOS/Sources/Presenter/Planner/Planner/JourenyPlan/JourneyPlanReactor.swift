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
        case tapEditButton(IndexPath)
        case tapPlusButton(IndexPath)
    }
    
    enum Mutation {
        case setSections([JourneyPlanSectionModel])
        case updateSectionItem(IndexPath, JourneyPlanSectionModel.Item)
    }
    
    struct State {
        var sections: [JourneyPlanSectionModel] = []
    }
    
    let service = ServiceProvider.shared.plannerService
    var initialState: State
    
    init(state: State) {
        initialState = state
    }
}

extension JourneyPlanReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .tapEditButton(indexPath):
            return tapEditButtonMutation(indexPath)
            
        case let .tapPlusButton(indexPath):
            return tapPlusButtonMutation(indexPath)
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = service.event.withUnretained(self).flatMap { (this, event) -> Observable<Mutation> in
            switch event {
            case let .fetchJourney(journey):
                return .just(.setSections(this.makeSections(from: journey)))
                
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
    
    private func tapEditButtonMutation(_ indexPath: IndexPath) -> Observable<Mutation> {
        guard let journey = service.journey else { return .empty() }
        guard case let .plan(reactor) = currentState.sections[indexPath.section].items[indexPath.item] else { return .empty() }
        service.presentPlannerRoute(from: makeReactor(from: reactor, pikis: journey.pikis[indexPath.section], pikmis: journey.pikmis))
        return .empty()
    }
    
    private func tapPlusButtonMutation(_ indexPath: IndexPath) -> Observable<Mutation> {
        guard let journey = service.journey else { return .empty() }
        guard case let .emptyPlan(reactor) = currentState.sections[indexPath.section].items[indexPath.item] else { return .empty() }
        service.presentPlannerRoute(from: makeReactor(from: reactor, pikis: journey.pikis[indexPath.section], pikmis: journey.pikmis))
        return .empty()
    }
    
    private func makeSections(from journey: Journey) -> [JourneyPlanSectionModel] {
        var journeyPlanSectionModels: [JourneyPlanSectionModel] = []
        
        let daySectionItems = journey.pikis.enumerated().map { (index, _) -> JourneyPlanItem in
            return JourneyPlanItem.dayTag(DayTagCollectionViewCellReactor(state: .init(day: index + 1)))
        }
        
        let journeySectionModels = journey.pikis.enumerated().map { (index, pikis) -> JourneyPlanSectionModel in
            var journeyPlanItems: [JourneyPlanItem] = []
            
            if pikis.isEmpty {
                let sectionItem = JourneyPlanItem.emptyPlan(EmptyPlanCollectionViewCellReactor(state: .init(order: index, date: DateManager.addDateComponent(byAdding: .day, value: index, to: Date(timeIntervalSince1970: journey.startDate)))))
                
                journeyPlanItems.append(sectionItem)
            } else {
                let sectionItems = pikis.enumerated().map { (index, pik) -> JourneyPlanItem in
                    return JourneyPlanItem.plan(PlanCollectionViewCellReactor(state: .init(isLast: index == pikis.count - 1, order: index, date: DateManager.addDateComponent(byAdding: .day, value: index, to: Date(timeIntervalSince1970: journey.startDate)), pik: pik)))
                }
                
                journeyPlanItems.append(contentsOf: sectionItems)
            }
            
            return JourneyPlanSectionModel(model: JourneyPlanSection.journey(journeyPlanItems), items: journeyPlanItems)
        }
        
        let daySection = JourneyPlanSectionModel(model: JourneyPlanSection.day(daySectionItems), items: daySectionItems)
        
        journeyPlanSectionModels.append(daySection)
        journeyPlanSectionModels.append(contentsOf: journeySectionModels)
        
        return journeyPlanSectionModels
    }
    
    private func makeReactor(from reactor: PlanCollectionViewCellReactor, pikis: [Pik], pikmis: [Pik]) -> PlannerRouteReactor {
        let state = reactor.currentState
        return .init(state: .init(order: state.order, date: state.date, pikis: pikis, pikmis: pikmis))
    }
    
    private func makeReactor(from reactor: EmptyPlanCollectionViewCellReactor, pikis: [Pik], pikmis: [Pik]) -> PlannerRouteReactor {
        let state = reactor.currentState
        return .init(state: .init(order: state.order, date: state.date, pikis: pikis, pikmis: pikmis))
    }
}
