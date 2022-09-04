//
//  PlannerService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import RxSwift

enum PlannerEvent {
    case fetchJourney(Journey)
    case presentPlannerRoute(PlannerRouteReactor)
}

protocol PlannerServiceProtocol {
    var event: PublishSubject<PlannerEvent> { get }
    var journey: Journey? { get }
    
    func updateJourney(to journey: Journey)
    
    func makeSections(from journey: Journey) -> [DiscussionSectionModel]
    func makeSections(from journey: Journey) -> [JourneyPlanSectionModel]
}

class PlannerService: PlannerServiceProtocol {
    let event = PublishSubject<PlannerEvent>()
    var journey: Journey?
    
    func updateJourney(to journey: Journey) {
        self.journey = journey
        event.onNext(.fetchJourney(journey))
    }
    
    func makeSections(from journey: Journey) -> [DiscussionSectionModel] {
        guard let tags = journey.tags else { return [] }
        guard let pikmis = journey.pikmis else { return [] }
    
        let tagItems = tags.map { (tag) -> DiscussionItem in
            return DiscussionItem.tag(TagCollectionViewCellReactor(tag: tag))
        }
        let pikmiItems = pikmis.enumerated().map { (index, pik) -> DiscussionItem in
            return DiscussionItem.pikmi(PikmiCollectionViewCellReactor(state: .init(pik: pik, rank: index)))
        }
        
        let tagSection = DiscussionSectionModel(model: DiscussionSection.tag(tagItems), items: tagItems)
        let pikmiSection = DiscussionSectionModel(model: DiscussionSection.pikmi(pikmiItems), items: pikmiItems)
        
        return [tagSection, pikmiSection]
    }
    
    func makeSections(from journey: Journey) -> [JourneyPlanSectionModel] {
        guard let pikisList = journey.pikis else { return [] }
        
        var journeyPlanSectionModels: [JourneyPlanSectionModel] = []
        
        let daySectionItems = pikisList.enumerated().map { (index, _) -> JourneyPlanItem in
            return JourneyPlanItem.dayTag(DayTagCollectionViewCellReactor(state: .init(day: index + 1)))
        }
        
        let journeySectionModels = pikisList.enumerated().map { (index, pikis) -> JourneyPlanSectionModel in
            var journeyPlanItems: [JourneyPlanItem] = []
            
            if pikis.isEmpty {
                let sectionItem = JourneyPlanItem.emptyPiki(EmptyPikiCollectionViewCellReactor(state: .init(order: index, date: DateManager.addDateComponent(byAdding: .day, value: index, to: Date(timeIntervalSince1970: journey.startDate)))))
                
                journeyPlanItems.append(sectionItem)
            } else {
                let sectionItems = pikis.map { (pik) -> JourneyPlanItem in
                    return JourneyPlanItem.piki(PikiCollectionViewCellReactor(state: .init(order: index, date: DateManager.addDateComponent(byAdding: .day, value: index, to: Date(timeIntervalSince1970: journey.startDate)), pik: pik)))
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
}
