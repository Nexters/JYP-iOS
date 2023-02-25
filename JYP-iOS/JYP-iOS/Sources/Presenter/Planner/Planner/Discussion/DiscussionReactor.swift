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
        case refresh(Journey)
        case selectCell(IndexPath, DiscussionItem)
        case tapToggleButton
        case tapPlusButton
        case tapCreatePikmiCellButton(IndexPath)
        case tapPikmiCellInfoButton(IndexPath)
        case tapPikmiCellLikeButton(IndexPath, PikmiCollectionViewCellReactor.State)
    }
    
    enum Mutation {
        case setJourney(Journey)
        case setSections([DiscussionSectionModel])
        case updateSectionItem(IndexPath, DiscussionItem)
        case updateIsToggleOn(Bool)
    }
    
    struct State {
        var journey: Journey?
        var sections: [DiscussionSectionModel] = []
        var isToggleOn: Bool = true
    }
    
    var initialState: State
    
    private let journeyService: JourneyServiceType
    
    init(journeyService: JourneyServiceType) {
        self.journeyService = journeyService
        self.initialState = State()
    }
}

extension DiscussionReactor {
    func bind(action: Action) {
        self.action.onNext(action)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .refresh(journey):
            return .concat([
                .just(.setJourney(journey)),
                .just(.setSections(makeSections(journey: journey)))
            ])
            
        case .selectCell:
            return .empty()
            
        case .tapToggleButton:
            return .empty()
            
        case .tapPlusButton:
            return .empty()
            
        case let .tapCreatePikmiCellButton(indexPath):
            return .empty()
            
        case let .tapPikmiCellInfoButton(indexPath):
            return .empty()
            
        case let .tapPikmiCellLikeButton(indexPath, state):
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setJourney(journey):
            newState.journey = journey
            
        case let .setSections(sections):
            newState.sections = sections
            
        case let .updateSectionItem(indexPath, item):
            newState.sections[indexPath.section].items[indexPath.item] = item
            
        case let .updateIsToggleOn(bool):
            newState.isToggleOn = bool
        }
        
        return newState
    }

    private func makeSections(journey: Journey, type: SectionType = .defualt) -> [DiscussionSectionModel] {
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
