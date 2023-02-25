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
        case tapCellLikeButton(IndexPath, PikmiCollectionViewCellReactor.State)
        case tapCellInfoButton(IndexPath, PikmiCollectionViewCellReactor.State)
        case tapCellCreateButton(IndexPath)
        case tapToggleButton
        case tapPlusButton
    }
    
    enum Mutation {
        case setJourney(Journey)
        case setSections([DiscussionSectionModel])
        case toggle
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
            
        case .tapToggleButton:
            guard let journey = currentState.journey else { return .empty() }
            
            return .concat([
                .just(.toggle),
                .just(.setSections(makeSections(
                    journey: journey,
                    isEmpty: currentState.isToggleOn
                )))
            ])
            
        case let .tapCellLikeButton(_, state):
            guard let journey = currentState.journey else { return .empty() }

            journeyService.createPikmiLike(journeyId: journey.id, pikmiId: state.pik.id)
            
            return .empty()
            
        case .selectCell, .tapPlusButton, .tapCellInfoButton, .tapCellCreateButton:
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setJourney(journey): newState.journey = journey
        case let .setSections(sections): newState.sections = sections
        case .toggle: newState.isToggleOn.toggle()
        }
        
        return newState
    }

    private func makeSections(journey: Journey, isEmpty: Bool = false) -> [DiscussionSectionModel] {
        let tagItmes: [DiscussionItem] = {
            if isEmpty {
                return [.emptyTag]
            } else {
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
