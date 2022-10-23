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
        case tapCreatePikmiButton
        case tapPikmiInfoButton(IndexPath)
        case tapPikmiLikeButton(IndexPath)
    }
    
    enum Mutation {
        case setOriginSections([DiscussionSectionModel])
        case setSections([DiscussionSectionModel])
        case updateSectionItem(IndexPath, DiscussionSectionModel.Item)
        case presentTagBottomSheet(TagBottomSheetReactor?)
        case presentPlannerSearchPlace(PlannerSearchPlaceReactor?)
        case presentWeb(WebReactor?)
    }
    
    struct State {
        var originSections: [DiscussionSectionModel] = []
        var sections: [DiscussionSectionModel] = []
        var tagBottomSheetReactor: TagBottomSheetReactor?
        var plannerSearchPlaceReactor: PlannerSearchPlaceReactor?
        var webReactor: WebReactor?
    }
    
    let plannerService = ServiceProvider.shared.plannerService
    
    var initialState: State
    
    init() {
        initialState = State()
    }
}

extension DiscussionReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectCell(indexPath):
            return mutateSelectCell(indexPath)
        case let .tapToggleButton:
            
        case .tapCreatePikmiButton:
            return mutateTapCreatePikmiButton()
        case let .tapPikmiInfoButton(indexPath):
            return mutateTapPikmiInfoButton(indexPath)
        case let .tapPikmiLikeButton(indexPath):
            return mutateTapPikmiLikeButton(indexPath)
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = plannerService.event.withUnretained(self).flatMap { (this, event) -> Observable<Mutation> in
            switch event {
            case let .fetchJourney(journey):
                return Observable.just(Mutation.setSections(this.plannerService.makeSections(from: journey)))
            default:
                return .empty()
            }
        }
        
        return Observable.merge(mutation, eventMutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setOriginSections(sections):
            newState.originSections = sections
        case let .setSections(sections):
            newState.sections = sections
        case let .updateSectionItem(indexPath, item):
            newState.sections[indexPath.section].items[indexPath.row] = item
        case let .presentTagBottomSheet(reactor):
            newState.tagBottomSheetReactor = reactor
        case let .presentPlannerSearchPlace(reactor):
            newState.plannerSearchPlaceReactor = reactor
        case let .presentWeb(reactor):
            newState.webReactor = reactor
        }
        
        return newState
    }
    
    private func mutateSelectCell(_ indexPath: IndexPath) -> Observable<Mutation> {
        guard case let .tag(reactor) = currentState.sections[indexPath.section].items[indexPath.row] else { return .empty() }
        
        plannerService.presentTagBottomSheet(from: makeReactor(from: reactor))
        return .empty()
    }
    
    private func mutateTapToggleButton() -> Observable<Mutation> {
        if currentState.se
        
        return .just(.setSections([]))
    }
    
    private func mutateTapCreatePikmiButton() -> Observable<Mutation> {
        plannerService.presentPlannerSearchPlace(from: makeReactor())
        
        return .empty()
    }
    
    private func mutateTapPikmiInfoButton(_ indexPath: IndexPath) -> Observable<Mutation> {
        guard case let .pikmi(reactor) = currentState.sections[indexPath.section].items[indexPath.row] else { return .empty() }
        
        plannerService.presentWeb(from: makeReactor(from: reactor))
        
        return .empty()
    }
    
    private func mutateTapPikmiLikeButton(_ indexPath: IndexPath) -> Observable<Mutation> {
        return .empty()
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
