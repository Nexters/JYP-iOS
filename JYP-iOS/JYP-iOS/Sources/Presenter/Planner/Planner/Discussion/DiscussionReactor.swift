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
    enum SectionType {
        case empty
        case defualt
    }
    
    enum Action {
        case selectCell(IndexPath)
        case tapToggleButton
        case tapPlusButton
        case tapCreatePikmiCellButton(IndexPath)
        case tapPikmiCellInfoButton(IndexPath)
        case tapPikmiCellLikeButton(IndexPath, PikmiCollectionViewCellReactor.State)
    }
    
    enum Mutation {
        case setSections([DiscussionSectionModel])
        case updateSectionItem(IndexPath, DiscussionItem)
        case updateIsToggleOn(Bool)
    }
    
    struct State {
        let journey: Journey
        var sections: [DiscussionSectionModel] = []
        var isToggleOn: Bool = true
    }
    
    private let journeyService: JourneyServiceType
    
    var initialState: State
    
    init(journeyService: JourneyServiceType, journey: Journey) {
        self.journeyService = journeyService
        self.initialState = State(journey: journey)
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
            
        case let .tapPikmiCellLikeButton(indexPath, state):
            return tapPikmiCellLikeButtonMutation(indexPath, state)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setSections(sections):
            newState.sections = sections
            
        case let .updateSectionItem(indexPath, item):
            newState.sections[indexPath.section].items[indexPath.item] = item
            
        case let .updateIsToggleOn(bool):
            newState.isToggleOn = bool
        }
        
        return newState
    }
    
    private func selectCellMutation(_ indexPath: IndexPath) -> Observable<Mutation> {
        switch currentState.sections[indexPath.section].items[indexPath.item] {
        case let .tag(reactor):
//            provider.plannerService.presentTagBottomSheet(from: makeReactor(from: reactor))
            return .empty()
            
        case .emptyTag:
            return .empty()
            
        case .createPikmi:
            return .empty()
            
        case .pikmi:
            return .empty()
        }
    }
    
    private func tapToggleButtonMutation() -> Observable<Mutation> {
//        guard let journey = currentState.journey else { return .empty() }
        
        let updateIsToggleOnMutation: Observable<Mutation> = .just(.updateIsToggleOn(!currentState.isToggleOn))
        var setSectionsMutation: Observable<Mutation> {
            currentState.isToggleOn ?
                .just(.setSections(makeSections(from: currentState.journey, type: .empty))) :
                .just(.setSections(makeSections(from: currentState.journey)))
        }
        let sequence: [Observable<Mutation>] = [updateIsToggleOnMutation, setSectionsMutation]
        return .concat(sequence)
    }
    
    private func tapPlusButtonMutation() -> Observable<Mutation> {
//        provider.plannerService.presentPlannerSearchPlace(from: makeReactor())
        return .empty()
    }
    
    private func tapCreatePikmiCellButtonMutation(_ indexPath: IndexPath) -> Observable<Mutation> {
        guard case .createPikmi = currentState.sections[indexPath.section].items[indexPath.item] else { return .empty() }
        
//        provider.plannerService.presentPlannerSearchPlace(from: makeReactor())
        return .empty()
    }
    
    private func tapPikmiCellInfoButtonMutation(_ indexPath: IndexPath) -> Observable<Mutation> {
        guard case let .pikmi(reactor) = currentState.sections[indexPath.section].items[indexPath.item] else { return .empty() }
        
//        provider.plannerService.presentWeb(from: .init(url: reactor.currentState.pik.link))
        return .empty()
    }
    
    private func tapPikmiCellLikeButtonMutation(_ indexPath: IndexPath, _ state: PikmiCollectionViewCellReactor.State) -> Observable<Mutation> {
        if let likeBy = state.pik.likeBy, likeBy.contains(where: { $0.id == UserDefaultsAccess.get(key: .userID) }) {
//            provider.journeyService.deletePikmiLike(journeyId: currentState.id, pikmiId: state.pik.id)
        } else {
//            provider.journeyService.createPikmiLike(journeyId: currentState.id, pikmiId: state.pik.id)
        }
        return .empty()
    }
    
    private func makeSections(from journey: Journey, type: SectionType = .defualt) -> [DiscussionSectionModel] {
        let tagItmes: [DiscussionItem] = {
            switch type {
            case .empty:
                return [.emptyTag]
                
            case .defualt:
                return journey.tags.map { (tag) -> DiscussionItem in
                    return .tag(.init(tag: tag))
                }
            }
        }()
        
        var prevLikeByCount: Int = 0
        var rank: Int = -1
        var pikmiItems: [DiscussionItem] = journey.pikmis.sorted(by: { $0.likeBy?.count ?? 0 > $1.likeBy?.count ?? 0 }).enumerated().map { (index, pik) -> DiscussionItem in
            if let likeBy = pik.likeBy, likeBy.contains(where: { $0.id == UserDefaultsAccess.get(key: .userID) }) {
                if prevLikeByCount != likeBy.count {
                    rank += 1
                }
                prevLikeByCount = likeBy.count
                return .pikmi(.init(state: .init(pik: pik, rank: rank, isSelectedLikeButton: true, isReadyAnimate: true)))
            } else {
                return .pikmi(.init(state: .init(pik: pik, rank: index)))
            }
        }
        
        if pikmiItems.isEmpty {
            pikmiItems.append(.createPikmi(.init()))
        }
        
        let tagSectionModel: DiscussionSectionModel = .init(model: .tag(tagItmes), items: tagItmes)
        let pikmiSectionModel: DiscussionSectionModel = .init(model: .pikmi(pikmiItems), items: pikmiItems)
        
        return [tagSectionModel, pikmiSectionModel]
    }
}
