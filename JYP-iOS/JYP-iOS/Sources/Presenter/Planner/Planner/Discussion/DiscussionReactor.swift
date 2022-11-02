//
//  DiscussionReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class DiscussionReactor: Reactor {
    enum Action {
        case selectCell(IndexPath)
        case tapToggleButton
        case tapPlusButton
        case tapCreatePikmiCellButton(IndexPath)
        case tapPikmiCellInfoButton(IndexPath)
        case tapPikmiCellLikeButton(IndexPath)
    }
    
    enum Mutation {
        case setSections([DiscussionSectionModel])
        case presentTagBottomSheet(TagBottomSheetReactor?)
        case presentPlannerSearchPlace(PlannerSearchPlaceReactor?)
        case presentWeb(WebReactor?)
    }
    
    struct State {
        var sections: [DiscussionSectionModel] = []
        var tagBottomSheetReactor: TagBottomSheetReactor?
        var plannerSearchPlaceReactor: PlannerSearchPlaceReactor?
        var webReactor: WebReactor?
    }
    
    let service = ServiceProvider.shared.plannerService
    
    var initialState: State
    
    init() {
        initialState = State()
    }
}

extension DiscussionReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectCell(indexPath):
            return selectCellMutation(indexPath)
            
        case .tapToggleButton:
            return tapToggleButtonMutation()
            
        case .tapPlusButton:
            return tapPlusButtonMutation()
            
        case let .tapCreatePikmiCellButton(indexPath):
            return tapCreatePikmiCellButtonMutation(indexPath)
            
        case let .tapPikmiCellInfoButton(indexPath):
            return tapPikmiCellInfoButtonMutation(indexPath)
            
        case let .tapPikmiCellLikeButton(indexPath):
            return tapPikmiCellLikeButtonMutation(indexPath)
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
            
        case let .presentTagBottomSheet(reactor):
            newState.tagBottomSheetReactor = reactor
            
        case let .presentPlannerSearchPlace(reactor):
            newState.plannerSearchPlaceReactor = reactor
            
        case let .presentWeb(reactor):
            newState.webReactor = reactor
        }
        
        return newState
    }
    
    private func selectCellMutation(_ indexPath: IndexPath) -> Observable<Mutation> {
        switch currentState.sections[indexPath.section].items[indexPath.item] {
        case let .tag(reactor):
            service.presentTagBottomSheet(from: makeReactor(from: reactor))
            return .empty()
            
        case .createPikmi:
            return .empty()
            
        case .pikmi:
            return .empty()
        }
    }
    
    private func tapToggleButtonMutation() -> Observable<Mutation> {
        return .empty()
    }
    
    private func tapPlusButtonMutation() -> Observable<Mutation> {
        service.presentPlannerSearchPlace(from: makeReactor())
        return .empty()
    }
    
    private func tapCreatePikmiCellButtonMutation(_ indexPath: IndexPath) -> Observable<Mutation> {
        guard case let .createPikmi(reactor) = currentState.sections[indexPath.section].items[indexPath.item] else { return .empty() }
        
        service.presentPlannerSearchPlace(from: makeReactor())
        return .empty()
    }
    
    private func tapPikmiCellInfoButtonMutation(_ indexPath: IndexPath) -> Observable<Mutation> {
        guard case let .pikmi(reactor) = currentState.sections[indexPath.section].items[indexPath.item] else { return .empty() }
        return .empty()
    }
    
    private func tapPikmiCellLikeButtonMutation(_ indexPath: IndexPath) -> Observable<Mutation> {
        guard case let .pikmi(reactor) = currentState.sections[indexPath.section].items[indexPath.item] else { return .empty() }
        return .empty()
    }
    
//    private func mutateSelectCell(_ indexPath: IndexPath) -> Observable<Mutation> {
//        guard case let .tag(reactor) = currentState.sections[indexPath.section].items[indexPath.row] else { return .empty() }
//
//        plannerService.presentTagBottomSheet(from: makeReactor(from: reactor))
//        return .empty()
//    }
    
//    private func mutateTapToggleButton() -> Observable<Mutation> {
//        if currentState.se
//
//        return .just(.setSections([]))
//    }
    
//    private func mutateTapCreatePikmiButton() -> Observable<Mutation> {
//        plannerService.presentPlannerSearchPlace(from: makeReactor())
//
//        return .empty()
//    }
    
//    private func mutateTapPikmiInfoButton(_ indexPath: IndexPath) -> Observable<Mutation> {
//        guard case let .pikmi(reactor) = currentState.pikmiSections[indexPath.section].items[indexPath.row] else { return .empty() }
//
//        plannerService.presentWeb(from: makeReactor(from: reactor))
//
//        return .empty()
//    }
    
//    private func mutateTapPikmiLikeButton(_ indexPath: IndexPath) -> Observable<Mutation> {
//        return .empty()
//    }
    
    private func makeSections(from journey: Journey) -> [DiscussionSectionModel] {
        let tagSectionItmes: [DiscussionItem] = journey.tags.map { (tag) -> DiscussionItem in
            return .tag(.init(tag: tag))
        }

        var pikmiItems: [DiscussionItem] = journey.pikmis.enumerated().map { (index, pik) -> DiscussionItem in
            return .pikmi(.init(state: .init(pik: pik, rank: index)))
        }

        if pikmiItems.isEmpty {
            pikmiItems.append(.createPikmi(.init()))
        }

        let tagSectionModel: DiscussionSectionModel = .init(model: .tag(tagSectionItmes), items: tagSectionItmes)
        let pikmiSectionModel: DiscussionSectionModel = .init(model: .pikmi(pikmiItems), items: pikmiItems)
        
        return [tagSectionModel, pikmiSectionModel]
    }
    
    private func makeReactor(from reactor: TagCollectionViewCellReactor) -> TagBottomSheetReactor {
        return .init(state: .init(tag: reactor.currentState))
    }
    
    private func makeReactor() -> PlannerSearchPlaceReactor {
        return .init()
    }
    
    private func makeReactor(from reactor: PikmiCollectionViewCellReactor) -> WebReactor {
        return .init(state: .init(url: reactor.currentState.pik.link))
    }
}
