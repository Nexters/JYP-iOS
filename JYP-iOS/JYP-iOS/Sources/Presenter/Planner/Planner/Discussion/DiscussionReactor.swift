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
    enum Action { }
    
    enum Mutation {
        case setSections([DiscussionSectionModel])
        case updateSectionItem(IndexPath, DiscussionSectionModel.Item)
    }
    
    struct State {
        var sections: [DiscussionSectionModel]
    }
    
    let plannerService = ServiceProvider.shared.plannerService
    var initialState: State
    
    init() {
        initialState = .init(sections: [])
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let eventMutation = plannerService.event.withUnretained(self).flatMap { (this, event) -> Observable<Mutation> in
            switch event {
            case let .fetchJourney(journey):
                return Observable.just(Mutation.setSections(this.plannerService.makeSections(from: journey)))
            }
        }
        
        return Observable.merge(mutation, eventMutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setSections(sections):
            newState.sections = sections
        case let .updateSectionItem(indexPath, item):
            newState.sections[indexPath.section].items[indexPath.row] = item
        }
        
        return newState
    }
}
