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
    case presentTagBottomSheet(TagBottomSheetReactor?)
    case presentPlannerSearchPlace(PlannerSearchPlaceReactor?)
    case presentWeb(WebReactor?)
    case presentPlannerRoute(PlannerRouteReactor?)
}

protocol PlannerServiceProtocol {
    var event: PublishSubject<PlannerEvent> { get }
    var journey: Journey? { get }
    
    func updateJourney(to journey: Journey)
    
    func presentTagBottomSheet(from reactor: TagBottomSheetReactor)
    func presentPlannerSearchPlace(from reactor: PlannerSearchPlaceReactor)
    func presentWeb(from reactor: WebReactor)
    func presentPlannerRoute(from reactor: PlannerRouteReactor)
    
//    func makeSections(from journey: Journey) -> [DiscussionTagSectionModel]
//    func makeSections(from journey: Journey) -> [DiscussionPikmiSectionModel]
//    func makeSections(from journey: Journey) -> [JourneyPlanSectionModel]
}

class PlannerService: PlannerServiceProtocol {
    let event = PublishSubject<PlannerEvent>()
    var journey: Journey?
    
    func updateJourney(to journey: Journey) {
        self.journey = journey
        event.onNext(.fetchJourney(journey))
    }
    
    func presentTagBottomSheet(from reactor: TagBottomSheetReactor) {
        event.onNext(.presentTagBottomSheet(reactor))
        event.onNext(.presentTagBottomSheet(nil))
    }
    
    func presentPlannerSearchPlace(from reactor: PlannerSearchPlaceReactor) {
        event.onNext(.presentPlannerSearchPlace(reactor))
        event.onNext(.presentPlannerSearchPlace(nil))
    }
    
    func presentWeb(from reactor: WebReactor) {
        event.onNext(.presentWeb(reactor))
        event.onNext(.presentWeb(nil))
    }
    
    func presentPlannerRoute(from reactor: PlannerRouteReactor) {
        event.onNext(.presentPlannerRoute(reactor))
        event.onNext(.presentPlannerRoute(nil))
    }
    
//    func makeSections(from journey: Journey) -> [DiscussionTagSectionModel] {
//        let items: [DiscussionTagItem] = journey.tags.map { (tag) -> DiscussionTagItem in
//            return .tag(.init(tag: tag))
//        }
//        let section: DiscussionTagSectionModel = .init(model: .tag(items), items: items)
//        
//        return [section]
//    }
//    
//    func makeSections(from journey: Journey) -> [DiscussionPikmiSectionModel] {
//        var items: [DiscussionPikmiItem] = []
//        var section: DiscussionPikmiSectionModel
//        
//        if journey.pikmis.isEmpty {
//            items.append(.createPikmi(.init()))
//        } else {
//            let pikmiItems = journey.pikmis.enumerated().map { (index, pik) -> DiscussionPikmiItem in
//                return .pikmi(.init(state: .init(pik: pik, rank: index)))
//            }
//            items.append(contentsOf: pikmiItems)
//        }
//        section = .init(model: .pikmi(items), items: items)
//        
//        return [section]
//    }
    
//    func makeSections(from journey: Journey) -> [JourneyPlanSectionModel] {
//        var journeyPlanSectionModels: [JourneyPlanSectionModel] = []
//
//        let daySectionItems = journey.pikis.enumerated().map { (index, _) -> JourneyPlanItem in
//            return JourneyPlanItem.dayTag(DayTagCollectionViewCellReactor(state: .init(day: index + 1)))
//        }
//
//        let journeySectionModels = journey.pikis.enumerated().map { (index, pikis) -> JourneyPlanSectionModel in
//            var journeyPlanItems: [JourneyPlanItem] = []
//
//            if pikis.isEmpty {
//                let sectionItem = JourneyPlanItem.emptyPiki(EmptyPlanCollectionViewCellReactor(state: .init(order: index, date: DateManager.addDateComponent(byAdding: .day, value: index, to: Date(timeIntervalSince1970: journey.startDate)))))
//
//                journeyPlanItems.append(sectionItem)
//            } else {
//                let sectionItems = pikis.map { (pik) -> JourneyPlanItem in
//                    return JourneyPlanItem.piki(PlanCollectionViewCellReactor(state: .init(order: index, date: DateManager.addDateComponent(byAdding: .day, value: index, to: Date(timeIntervalSince1970: journey.startDate)), pik: pik)))
//                }
//
//                journeyPlanItems.append(contentsOf: sectionItems)
//            }
//
//            return JourneyPlanSectionModel(model: JourneyPlanSection.journey(journeyPlanItems), items: journeyPlanItems)
//        }
//
//        let daySection = JourneyPlanSectionModel(model: JourneyPlanSection.day(daySectionItems), items: daySectionItems)
//
//        journeyPlanSectionModels.append(daySection)
//        journeyPlanSectionModels.append(contentsOf: journeySectionModels)
//
//        return journeyPlanSectionModels
//    }
}
