//
//  PlannerRouteReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import ReactorKit

class PlannerRouteReactor: Reactor {
    enum Action {
        case refresh
    }
    enum Mutation {
        case setSections([PlannerRouteSectionModel])
        case updateSectionItem(IndexPath, PlannerRouteSectionModel.Item)
    }
    
    struct State {
        let order: Int
        let date: Date
        let pikmis: [Pik]
        
        var sections: [PlannerRouteSectionModel] = []
    }
    
    let provider = ServiceProvider.shared
    var initialState: State
    
    init(state: State) {
        self.initialState = state
    }
}

extension PlannerRouteReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .just(.setSections(makeSections(pikmis: currentState.pikmis)))
        }
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
    
    private func makeSections(pikmis: [Pik]) -> [PlannerRouteSectionModel] {
        print("[D] \(pikmis)")
        let routeSection = PlannerRouteSectionModel(model: .route([]), items: [])
        
        let pikmiRouteItems = pikmis.enumerated().map({ (index, pik) -> PlannerRouteItem in
            return .pikmiRoute(.init(state: .init(pik: pik, rank: index)))
        })
        
        let pikmiRouteSection = PlannerRouteSectionModel(model: .pikmiRoute(pikmiRouteItems), items: pikmiRouteItems)
        
        return [routeSection, pikmiRouteSection]
    }
}
