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
        case refresh(Journey)
        case selectCell(IndexPath, JourneyPlanItem)
        case tapEditButton(IndexPath)
        case tapPlusButton(IndexPath)
    }
    
    enum Mutation {
        case setJourney(Journey)
        case setSections([JourneyPlanSectionModel])
        case updateSectionItem(IndexPath, JourneyPlanSectionModel.Item)
    }
    
    struct State {
        var journey: Journey?
        var sections: [JourneyPlanSectionModel] = []
    }
    
    var initialState: State
    
    private let journeyService: JourneyServiceType
    
    init(journeyService: JourneyServiceType) {
        self.journeyService = journeyService
        self.initialState = State()
    }
}

extension JourneyPlanReactor {
    func bind(action: Action) {
        self.action.onNext(action)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .refresh(journey): return .just(.setJourney(journey))
        case .selectCell: return .empty()
        case let .tapEditButton(indexPath): return .empty()
        case let .tapPlusButton(indexPath): return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setJourney(Journey): newState.journey = Journey
        case let .setSections(sections): newState.sections = sections
        case let .updateSectionItem(indexPath, item): newState.sections[indexPath.section].items[indexPath.row] = item
        }
        
        return newState
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
}
