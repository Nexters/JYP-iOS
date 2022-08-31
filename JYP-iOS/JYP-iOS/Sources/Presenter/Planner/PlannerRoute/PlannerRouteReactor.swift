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
        case tapPikmiRouteCell(IndexPath)
    }
    enum Mutation {
        case setPikmiRouteSections([PikmiRouteSectionModel])
        case setRouteSections([RouteSectionModel])
        case updatePikmiRouteSectionItem(IndexPath, PikmiRouteSectionModel.Item)
        case updateRouteSectionItem(IndexPath, RouteSectionModel.Item)
        case appendRouteSectionItem(IndexPath, RouteSectionModel.Item)
    }
    
    struct State {
        let order: Int
        let date: Date
        let pikmis: [Pik]
        
        var routeSections: [RouteSectionModel] = []
        var pikmiRouteSections: [PikmiRouteSectionModel] = []
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
            return .concat([
                .just(.setRouteSections(makeSections())),
                .just(.setPikmiRouteSections(makeSections(pikmis: currentState.pikmis)))
            ])
        case let .tapPikmiRouteCell(indexPath):
            guard case let .pikmiRoute(reactor) = currentState.pikmiRouteSections[indexPath.section].items[indexPath.row] else { return .empty() }
            let item = RouteSectionModel.Item.route(.init(state: .init(pik: reactor.currentState.pik)))
            
            return .just(.appendRouteSectionItem(indexPath, item))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setPikmiRouteSections(sections):
            newState.pikmiRouteSections = sections
        case let .setRouteSections(sections):
            newState.routeSections = sections
        case let .updatePikmiRouteSectionItem(indexPath, item):
            newState.pikmiRouteSections[indexPath.section].items[indexPath.row] = item
        case let .updateRouteSectionItem(indexPath, item):
            newState.routeSections[indexPath.section].items[indexPath.row] = item
        case let .appendRouteSectionItem(indexPath, item):
            newState.routeSections[indexPath.section].items.append(item)
        }
        
        return newState
    }
    
    private func makeSections() -> [RouteSectionModel] {
        return [RouteSectionModel.init(model: .route([RouteItem.route(.init(state: .init(pik: nil)))]), items: [])]
    }
    
    private func makeSections(pikmis: [Pik]) -> [PikmiRouteSectionModel] {
        let pikmiRouteItems = pikmis.enumerated().map({ (index, pik) -> PikmiRouteItem in
            return .pikmiRoute(.init(state: .init(pik: pik, rank: index)))
        })
        
        let pikmiRouteSection = PikmiRouteSectionModel(model: .pikmiRoute(pikmiRouteItems), items: pikmiRouteItems)
        
        return [pikmiRouteSection]
    }
}
