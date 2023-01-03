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
        case tapPikmiRouteCell(IndexPath, PikmiRouteSectionModel.Item)
        case tapDoneButton
    }
    enum Mutation {
        case setJourney(Journey)
        case setRouteSections([RouteSectionModel])
        case deleteRouteSectionItem(IndexPath)
        case setPikmiRouteSections([PikmiRouteSectionModel])
        case updatePikmiRouteSectionItem(IndexPath, PikmiRouteSectionModel.Item)
        case updateRouteSectionItem(IndexPath, RouteSectionModel.Item)
        case appendRouteSectionItem(IndexPath, RouteSectionModel.Item)
        case setDidUpdatePikis(Bool)
    }
    
    struct State {
        var journey: Journey
        let order: Int
        var routeSections: [RouteSectionModel] = []
        var pikmiRouteSections: [PikmiRouteSectionModel] = []
        var didUpdatePikis: Bool = false
    }
    
    var initialState: State
    
    let provider = ServiceProvider.shared
    let journeyService: JourneyServiceType
    
    init(journey: Journey,
         order: Int,
         journeyService: JourneyServiceType) {
        self.journeyService = journeyService
        self.initialState = .init(journey: journey, order: order)
    }
}

extension PlannerRouteReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            journeyService.fetchJorney(id: currentState.journey.id)
            let pikis = currentState.journey.pikidays[currentState.order].pikis
            let pikmis = currentState.journey.pikmis
            
            return .concat([
                .just(.setRouteSections(makeSections(pikis: pikis))),
                .just(.setPikmiRouteSections(makeSections(pikmis: pikmis)))
            ])
            
        case let .tapRouteCell(indexPath):
            return .just(.deleteRouteSectionItem(indexPath))
            
        case let .tapPikmiRouteCell(indexPath, item):
            guard case let .pikmiRoute(reactor) = item else { return .empty() }
            let pik = reactor.currentState.pik
            
            var pikis: [Pik] = []
            currentState.routeSections[safe: 0]?.items.forEach { item in
                if case let .route(reactor) = item {
                    pikis.append(reactor.currentState.pik)
                }
            }
            if pikis.contains(where: { $0.id == pik.id }) {
                return .empty()
            } else {
                let reactor: RouteCollectionViewCellReactor = .init(state: .init(pik: pik))
                let item: RouteSectionModel.Item = .route(reactor)
                
                return .just(.appendRouteSectionItem(indexPath, item))
            }
            
        case .tapDoneButton:
            var pikis: [Pik] = []
            currentState.routeSections[safe: 0]?.items.forEach { item in
                if case let .route(reactor) = item {
                    pikis.append(reactor.currentState.pik)
                }
            }
            journeyService.updatePikis(journeyId: currentState.journey.id, request: .init(index: currentState.order, pikis: pikis))
            return .empty()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let journeyServiceMutation = journeyService.event.withUnretained(self).flatMap { (this, event) -> Observable<Mutation> in
            switch event {
            case let .fetchJourney(journey):
                return .concat([
                    .just(.setJourney(journey)),
                    .just(.setPikmiRouteSections(this.makeSections(pikmis: journey.pikmis)))
                ])
            case .updatePikis:
                return .concat([
                    .just(.setDidUpdatePikis(true)),
                    .just(.setDidUpdatePikis(false))
                ])
            default:
                return .empty()
            }
        }

        return Observable.merge(mutation, journeyServiceMutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setJourney(journey):
            newState.journey = journey
            
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
