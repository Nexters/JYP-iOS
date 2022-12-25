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
        case setJourney(Journey)
        case setSections([JourneyPlanSectionModel])
        case updateSectionItem(IndexPath, JourneyPlanSectionModel.Item)
    }
    
    struct State {
        var id: String
        var journey: Journey?
        var sections: [JourneyPlanSectionModel] = []
    }
    
    let provider = ServiceProvider.shared
    var initialState: State
    
    init(id: String) {
        self.initialState = State(id: id)
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
        let APIMutation = provider.journeyService.event.withUnretained(self).flatMap { (this, event) -> Observable<Mutation> in
            switch event {
            case let .fetchJourney(journey):
                return .concat([.just(.setJourney(journey)),
                                .just(.setSections(this.makeSections(from: journey)))])
                
            default:
                return .empty()
            }
        }
        
        return Observable.merge(mutation, APIMutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setJourney(journey):
            newState.journey = journey
            
        case let .setSections(sections):
            newState.sections = sections
            
        case let .updateSectionItem(indexPath, item):
            newState.sections[indexPath.section].items[indexPath.row] = item
        }
        
        return newState
    }
    
    private func tapEditButtonMutation(_ indexPath: IndexPath) -> Observable<Mutation> {
        guard let journey = currentState.journey else { return .empty() }
        guard case let .plan(reactor) = currentState.sections[indexPath.section].items[indexPath.item] else { return .empty() }
        provider.plannerService.presentPlannerRoute(from: makeReactor(from: reactor, pikis: journey.pikidays[indexPath.section].pikis, pikmis: journey.pikmis))
        return .empty()
    }
    
    private func tapPlusButtonMutation(_ indexPath: IndexPath) -> Observable<Mutation> {
        guard let journey = currentState.journey else { return .empty() }
        guard case let .emptyPlan(reactor) = currentState.sections[indexPath.section].items[indexPath.item] else { return .empty() }
        provider.plannerService.presentPlannerRoute(from: makeReactor(from: reactor, pikis: journey.pikidays[indexPath.section].pikis, pikmis: journey.pikmis))
        return .empty()
    }
    
    private func makeSections(from journey: Journey) -> [JourneyPlanSectionModel] {
        var sections: [JourneyPlanSectionModel] = []
        
        let dayItems = journey.pikidays.enumerated().map { (index, _) -> JourneyPlanItem in
            return JourneyPlanItem.dayTag(DayTagCollectionViewCellReactor(state: .init(day: index + 1)))
        }
        
        if dayItems.isEmpty == false {
            sections.append(.init(model: .day(dayItems), items: dayItems))
        }
        
        journey.pikidays.enumerated().forEach { (index, pikiday) in
            var journeyPlanItems: [JourneyPlanItem] = []
            
            if pikiday.pikis.isEmpty {
                let sectionItem = JourneyPlanItem.emptyPlan(EmptyPlanCollectionViewCellReactor(state: .init(order: index, date: DateManager.addDateComponent(byAdding: .day, value: index, to: Date(timeIntervalSince1970: journey.startDate)))))
                
                journeyPlanItems.append(sectionItem)
            } else {
                let sectionItems = pikiday.pikis.enumerated().map { (index, pik) -> JourneyPlanItem in
                    return JourneyPlanItem.plan(PlanCollectionViewCellReactor(state: .init(isLast: index == pikiday.pikis.count - 1, order: index, date: DateManager.addDateComponent(byAdding: .day, value: index, to: Date(timeIntervalSince1970: journey.startDate)), pik: pik)))
                }
                
                journeyPlanItems.append(contentsOf: sectionItems)
            }
            
            sections.append(.init(model: .journey(journeyPlanItems), items: journeyPlanItems))
        }
        
        return sections
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
