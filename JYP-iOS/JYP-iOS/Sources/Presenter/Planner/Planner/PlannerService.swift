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
    case fetchJourney(NewJourney)
}

protocol PlannerServiceProtocol {
    var event: PublishSubject<PlannerEvent> { get }

    func updateJourney(to journey: NewJourney)
    
    func makeSections(from journey: NewJourney) -> [DiscussionSectionModel]
    func makeSections(from journey: NewJourney) -> [JourneyPlanSectionModel]
}

class PlannerService: PlannerServiceProtocol {
    let event = PublishSubject<PlannerEvent>()
    var journey: NewJourney?
    
    func updateJourney(to journey: NewJourney) {
        self.journey = journey
        event.onNext(.fetchJourney(journey))
    }
    
    func makeSections(from journey: NewJourney) -> [DiscussionSectionModel] {
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
    
    func makeSections(from journey: NewJourney) -> [JourneyPlanSectionModel] {
        guard let pikisList = journey.pikis else { return [] }
        
        let dayTagItems = pikisList.enumerated().map { (index, _) -> JourneyPlanItem in
            return JourneyPlanItem.dayTag(DayTagCollectionViewCellReactor(state: .init(day: index + 1)))
        }
        
        let journeyPlanItems = pikisList.map { (pikis) -> JourneyPlanItem in
            let pikiItems = pikis.map { (pik) -> PikiItem in
                return PikiItem.piki(PikiCollectionViewCellReactor(state: pik))
            }
            
            let pikiSection = PikiSectionModel(model: PikiSection.piki(pikiItems), items: pikiItems)
            
            return JourneyPlanItem.journeyPlan(JourneyPlanCollectionViewCellReactor(state: [pikiSection]))
        }

        let dayTagSection = JourneyPlanSectionModel(model: JourneyPlanSection.dayTag(dayTagItems), items: dayTagItems)
        let journeyPlanSection = JourneyPlanSectionModel(model: JourneyPlanSection.journeyPlan(journeyPlanItems), items: journeyPlanItems)
        
        return [dayTagSection, journeyPlanSection]
    }
}
