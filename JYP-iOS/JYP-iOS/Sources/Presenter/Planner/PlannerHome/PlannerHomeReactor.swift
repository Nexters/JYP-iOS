//
//  DiscussionHomeReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class PlannerHomeReactor: Reactor {
    enum Action {
        case refresh
        case didTapDiscussion
        case didTapJourneyPlanner
        case didTapJYPTagToggleButton
        case didTapAddCandidatePlaceButton
        case didTapDiscussionCollecionViewCell(IndexPath)
        case didTapCandidatePlaceInfoButton(IndexPath)
        case didTapCandidatePlaceLikeButton(IndexPath)
    }

    enum Mutation {
        case updateIsShowDiscussion(Bool)
        case updateIsShowJourneyPlanner(Bool)
        case updateIsShowJYPTagSectionToggle
        case updateTagPresentJYPTagBottomSheet(Tag)
        case updateIsPresentPlannerSearchPlaceViewController(Bool)
        case updateCandidatePlacePresentPlannerSearchPlaceWebViewController(CandidatePlace)
        case setSections([PlannerHomeDiscussionSectionModel])
        case updateSectionItem(IndexPath, PlannerHomeDiscussionSectionModel.Item)
    }

    struct State {
        var isShowDiscussion: Bool = true
        var isShowJourneyPlanner: Bool = false
        var isShowJYPTagSection: Bool = true
        var tagPresentJYPTagBottomSheet: Tag?
        var isPresentPlannerSearchPlaceViewController: Bool = false
        var candidatePlacePresentPlannerSearchPlaceWebViewController: CandidatePlace?
        var sections: [PlannerHomeDiscussionSectionModel]
    }

    let provider: ServiceProviderType
    let initialState: State

    init(provider: ServiceProviderType) {
        self.provider = provider
        initialState = State(sections: [])
    }
}

extension PlannerHomeReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        let state = self.currentState
        
        switch action {
        case .refresh:
            return provider.journeyService.fetchJorney(id: 0)
                .map { journey in
                    let tags = journey.tags
                    let candidatePlaces = journey.candidatePlaces
                    
                    let jypTagItems = tags.map { (tag) -> PlannerHomeDiscussionItem in
                        return .jypTagItem(.init(tag: tag))
                    }
                    let jypTagSection = PlannerHomeDiscussionSectionModel(model: .jypTagSection(jypTagItems), items: jypTagItems)
                    
                    let candidatePlaceItems = candidatePlaces.enumerated().map { (index, candidatePlace) -> PlannerHomeDiscussionItem in
                        return .candidatePlaceItem(.init(state: .init(candidatePlace: candidatePlace, rank: index)))
                    }
                    let candidatePlaceSection = PlannerHomeDiscussionSectionModel(model: .candidatePlaceSection(candidatePlaceItems), items: candidatePlaceItems)
                    
                    return .setSections([jypTagSection, candidatePlaceSection])
                }
        case .didTapDiscussion:
            let sequence: [Observable<Mutation>] = [
                .just(.updateIsShowDiscussion(true)),
                .just(.updateIsShowJourneyPlanner(false))
            ]
            
            return .concat(sequence)
        case .didTapJourneyPlanner:
            let sequence: [Observable<Mutation>] = [
                .just(.updateIsShowDiscussion(false)),
                .just(.updateIsShowJourneyPlanner(true))
            ]
            
            return .concat(sequence)
        case .didTapJYPTagToggleButton:
            return .just(.updateIsShowJYPTagSectionToggle)
        case .didTapAddCandidatePlaceButton:
            return .just(.updateIsPresentPlannerSearchPlaceViewController(true))
        case let .didTapDiscussionCollecionViewCell(indexPath):
            switch state.sections[indexPath.section].items[indexPath.row] {
            case let .jypTagItem(reactor):
                let tag = reactor.currentState
                
                return .just(.updateTagPresentJYPTagBottomSheet(tag))
            case .candidatePlaceItem: break
            }
        case let .didTapCandidatePlaceInfoButton(indexPath):
            guard case let .candidatePlaceItem(reactor) = state.sections[indexPath.section].items[indexPath.row] else { break }
            let candidatePlace = reactor.currentState.candidatePlace
            
            return .just(.updateCandidatePlacePresentPlannerSearchPlaceWebViewController(candidatePlace))
        case let .didTapCandidatePlaceLikeButton(indexPath):
            guard case let .candidatePlaceItem(reactor) = state.sections[indexPath.section].items[indexPath.row] else { break }
            var candidatePlaceItemState = reactor.currentState
            
            candidatePlaceItemState.candidatePlace.like += candidatePlaceItemState.isSelectedLikeButton ? 1 : -1
            
            return .just(.updateSectionItem(indexPath, .candidatePlaceItem(.init(state: candidatePlaceItemState))))
        }
        return .empty()
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        return action
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateIsShowDiscussion(bool):
            newState.isShowDiscussion = bool
        case let .updateIsShowJourneyPlanner(bool):
            newState.isShowJourneyPlanner = bool
        case .updateIsShowJYPTagSectionToggle:
            newState.isShowJYPTagSection.toggle()
        case let .updateTagPresentJYPTagBottomSheet(tag):
            newState.tagPresentJYPTagBottomSheet = tag
        case let .updateIsPresentPlannerSearchPlaceViewController(bool):
            newState.isPresentPlannerSearchPlaceViewController = bool
        case let .updateCandidatePlacePresentPlannerSearchPlaceWebViewController(candidatePlace):
            newState.candidatePlacePresentPlannerSearchPlaceWebViewController = candidatePlace
        case let .setSections(plannerHomeDiscussionSectionModels):
            newState.sections = plannerHomeDiscussionSectionModels
        case let .updateSectionItem(indexPath, sectionItem):
            newState.sections[indexPath.section].items[indexPath.row] = sectionItem
        }
        
        return newState
    }
}

extension PlannerHomeReactor {
//    static func makeSections() -> [PlannerHomeDiscussionSectionModel] {
//        let tags: [Tag] = [.init(id: "1", text: "바다", type: .like), .init(id: "2", text: "해산물", type: .like), .init(id: "3", text: "산", type: .like), .init(id: "4", text: "핫 플레이스", type: .dislike), .init(id: "5", text: "도시", type: .dislike), .init(id: "6", text: "상관없어", type: .soso)]
//
//        let candidatePlaces: [CandidatePlace] = [.init(id: "1", name: "아르떼 뮤지엄", address: "강원 강릉시 난설헌로 131", category: .culture, like: 1, lon: 0.124, lan: 0.124, url: "https://www.naver.com/"),.init(id: "1", name: "아르떼 뮤지엄", address: "강원 강릉시 난설헌로 131", category: .culture, like: 1, lon: 0.124, lan: 0.124, url: "https://www.naver.com/"),.init(id: "1", name: "아르떼 뮤지엄", address: "강원 강릉시 난설헌로 131", category: .culture, like: 1, lon: 0.124, lan: 0.124, url: "https://www.naver.com/")]
//
////        let journeyTagSection = PlannerDiscussionSectionModel(model: .journeyTag(tags), items: tags.map(PlannerDiscussionSectionModel.Item.tagCell))
////        let candidatePlaceSection = PlannerDiscussionSectionModel(model: .candidatePlace(candidatePlaces), items: candidatePlaces.map(PlannerDiscussionSectionModel.Item.candidatePlaceCell))
//
//        let jypTagItems = tags.map { (tag) -> PlannerHomeDiscussionItem in
//            return .jypTagItem(.init(tag: tag))
//        }
//        let jypTagSection = PlannerHomeDiscussionSectionModel(model: .jypTagSection(jypTagItems), items: jypTagItems)
//
//        let candidatePlaceItems = candidatePlaces.map { (candidatePlace) -> PlannerHomeDiscussionItem in
//            return .candidatePlaceItem(.init(state: .init(candidatePlace: candidatePlace)))
//        }
//        let candidatePlaceSection = PlannerHomeDiscussionSectionModel(model: .candidatePlaceSection(candidatePlaceItems), items: candidatePlaceItems)
//
//        return [jypTagSection, candidatePlaceSection]
//    }
}
