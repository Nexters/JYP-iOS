//
//  PlannerRouteReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class PlannerRouteReactor: Reactor {
    enum Action {
        case refresh
        case tapRouteCell(IndexPath)
        case tapPikmiRouteCell(IndexPath)
        case tapDoneButton
    }
    enum Mutation {
        case setRouteSections([RouteSectionModel])
        case deleteRouteSectionItem(IndexPath)
        case setPikmiRouteSections([PikmiRouteSectionModel])
        case updatePikmiRouteSectionItem(IndexPath, PikmiRouteSectionModel.Item)
        case updateRouteSectionItem(IndexPath, RouteSectionModel.Item)
        case appendRouteSectionItem(IndexPath, RouteSectionModel.Item)
        case setDidUpdatePikis(Bool)
    }
    
    struct State {
        let id: String
        let order: Int
        let date: Date
        let pikis: [Pik]
        let pikmis: [Pik]
        var routeSections: [RouteSectionModel] = []
        var pikmiRouteSections: [PikmiRouteSectionModel] = []
        var didUpdatePikis: Bool = false
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
                .just(.setRouteSections(makeSections(pikis: currentState.pikis))),
                .just(.setPikmiRouteSections(makeSections(pikmis: currentState.pikmis)))
            ])
            
        case let .tapRouteCell(indexPath):
            return .just(.deleteRouteSectionItem(indexPath))
            
        case let .tapPikmiRouteCell(indexPath):
            guard case let .pikmiRoute(reactor) = currentState.pikmiRouteSections[indexPath.section].items[indexPath.row] else { return .empty() }
            let item = RouteSectionModel.Item.route(.init(state: .init(pik: reactor.currentState.pik)))
            
            return .just(.appendRouteSectionItem(indexPath, item))
            
        case .tapDoneButton:
            var pikis: [Pik] = []
            currentState.routeSections.first?.items.forEach { (item) in
                if case let .route(reactor) = item {
                    pikis.append(reactor.currentState.pik)
                }
            }
            provider.journeyService.updatePikis(journeyId: currentState.id, request: .init(index: currentState.order, pikis: pikis))
            return .empty()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let APIMutation = provider.journeyService.event.withUnretained(self).flatMap { (_, event) -> Observable<Mutation> in
            switch event {
            case .updatePikis:
                return .concat([
                    .just(.setDidUpdatePikis(true)),
                    .just(.setDidUpdatePikis(false))
                ])
                
            default:
                return .empty()
            }
        }

        return Observable.merge(mutation, APIMutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setRouteSections(sections):
            newState.routeSections = sections
            
        case let .deleteRouteSectionItem(indexPath):
            newState.routeSections[indexPath.section].items.remove(at: indexPath.row)
            
        case let .setPikmiRouteSections(sections):
            newState.pikmiRouteSections = sections
            
        case let .updatePikmiRouteSectionItem(indexPath, item):
            newState.pikmiRouteSections[indexPath.section].items[indexPath.row] = item
            
        case let .updateRouteSectionItem(indexPath, item):
            newState.routeSections[indexPath.section].items[indexPath.row] = item
            
        case let .appendRouteSectionItem(indexPath, item):
            newState.routeSections[indexPath.section].items.append(item)
            
        case let .setDidUpdatePikis(bool):
            newState.didUpdatePikis = bool
        }
        
        return newState
    }
    
    private func makeSections(pikis: [Pik]) -> [RouteSectionModel] {
        if pikis.isEmpty {
            return [RouteSectionModel.init(model: .route([RouteItem.route(.init(state: .init(pik: Pik(id: "", name: "", address: "", category: .etc, likeBy: nil, longitude: 0.0, latitude: 0.0, link: ""))))]), items: [])]
        }
        
        let routeItems = pikis.map({ (pik) -> RouteItem in
            return .route(.init(state: .init(pik: pik)))
        })
        
        return [RouteSectionModel.init(model: .route(routeItems), items: routeItems)]
    }
    
    private func makeSections(pikmis: [Pik]) -> [PikmiRouteSectionModel] {
        let pikmiRouteItems = pikmis.enumerated().map({ (index, pik) -> PikmiRouteItem in
            return .pikmiRoute(.init(state: .init(pik: pik, rank: index)))
        })
        
        let pikmiRouteSection = PikmiRouteSectionModel(model: .pikmiRoute(pikmiRouteItems), items: pikmiRouteItems)
        
        return [pikmiRouteSection]
    }
}
