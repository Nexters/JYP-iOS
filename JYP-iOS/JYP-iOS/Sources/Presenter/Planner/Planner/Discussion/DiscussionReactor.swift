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
        case refresh(Journey)
        case fetch
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
    
    init() {
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
            
        case .fetch, .selectCell, .tapPlusButton, .tapCellInfoButton, .tapCellCreateButton, .tapCellLikeButton:
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
        var rank: Int = 0
        let pikmis = journey.pikmis.sorted(by: { $0.likeBy?.count ?? 0 > $1.likeBy?.count ?? 0 })
        
        var pikmiItems: [DiscussionItem] = pikmis.map { pik -> DiscussionItem in
            if let likeByCount = pik.likeBy?.count, likeByCount != prevLikeByCount {
                prevLikeByCount = likeByCount
                rank += 1
            }
            return .pikmi(.init(rank: rank, pik: pik))
        }
        
        if pikmiItems.isEmpty {
            pikmiItems.append(.createPikmi(.init()))
        }
        
        let tagSectionModel: DiscussionSectionModel = .init(model: .tag(tagItmes), items: tagItmes)
        let pikmiSectionModel: DiscussionSectionModel = .init(model: .pikmi(pikmiItems), items: pikmiItems)
        
        return [tagSectionModel, pikmiSectionModel]
    }
}
