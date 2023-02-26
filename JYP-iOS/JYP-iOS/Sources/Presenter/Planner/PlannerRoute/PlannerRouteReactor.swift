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
        case tapCellDeleteButton(IndexPath, RouteCollectionViewCellReactor.State)
        case tapPikmiRouteCell(IndexPath, PikmiRouteItem)
        case tapDoneButton
    }
    
    enum Mutation {
        case setRouteSections([RouteSectionModel])
        case appendRouteItem(RouteItem)
        case deleteRouteItem(IndexPath)
        
        case setPikmiRouteSections([PikmiRouteSectionModel])
        case popToPlanner
    }
    
    struct State {
        let index: Int
        let journey: Journey
        var routeSections: [RouteSectionModel] = []
        var pikmiRouteSections: [PikmiRouteSectionModel] = []
        var popToPlanner: Bool = false
    }
    
    var initialState: State
    
    let journeyService: JourneyServiceType
    
    init(index: Int, journey: Journey, journeyService: JourneyServiceType) {
        self.journeyService = journeyService
        self.initialState = .init(index: index, journey: journey)
    }
}

extension PlannerRouteReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            let pikis = currentState.journey.pikidays[initialState.index].pikis
            let pikmis = currentState.journey.pikmis
            
            return .concat([
                .just(.setRouteSections(makeSections(from: pikis))),
                .just(.setPikmiRouteSections(makeSections(from: pikmis)))
            ])
            
        case let .tapCellDeleteButton(indexPath, _):
            return .just(.deleteRouteItem(indexPath))
            
        case let .tapPikmiRouteCell(_, item):
            guard case let .pikmiRoute(reactor) = item else { return .empty() }
            let pik = reactor.currentState.pik
            let piks = piks(from: currentState.routeSections)
            
            if piks.contains(where: { $0.id == pik.id }) {
                return .empty()
            } else {
                return .just(.appendRouteItem(makeItem(from: pik)))
            }
            
        case .tapDoneButton:
            let piks = piks(from: currentState.routeSections)
            
            return journeyService.updatePikis(journeyId: currentState.journey.id, request: .init(index: currentState.index, pikis: piks)).map { _ in
                return .popToPlanner
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setRouteSections(sections):
            newState.routeSections = sections
            
        case let .appendRouteItem(item):
            newState.routeSections[0].items.append(item)
            
        case let .deleteRouteItem(indexPath):
            newState.routeSections[indexPath.section].items.remove(at: indexPath.item)
            
        case let .setPikmiRouteSections(sections):
            newState.pikmiRouteSections = sections
            
        case .popToPlanner:
            newState.popToPlanner = true
        }
        
        return newState
    }
}

extension PlannerRouteReactor {
    /// PikmiRouteSections를 만드는 함수
    /// - Parameter piks: RouteItem에 들어갈 pik
    /// - Returns: PikmiRouteSectionModel list
    private func makeSections(from piks: [Pik]) -> [RouteSectionModel] {
        if piks.isEmpty {
            return [RouteSectionModel.init(model: .route([RouteItem.route(.init(state: .init(pik: Pik(id: "", name: "", address: "", category: .etc, likeBy: nil, longitude: 0.0, latitude: 0.0, link: ""))))]), items: [])]
        }
        
        let routeItems = piks.map({ (pik) -> RouteItem in
            return makeItem(from: pik)
        })
        
        return [RouteSectionModel.init(model: .route(routeItems), items: routeItems)]
    }
    
    /// PikmiRouteSections를 만드는 함수
    /// - Parameter piks: RouteItem에 들어갈 pik
    /// - Returns: PikmiRouteSectionModel list
    private func makeSections(from piks: [Pik]) -> [PikmiRouteSectionModel] {
        var prevLikeByCount: Int = 0
        var rank: Int = -1
        var pikmiRouteItems: [PikmiRouteItem] = piks.sorted(by: { $0.likeBy?.count ?? 0 > $1.likeBy?.count ?? 0 }).enumerated().map { (index, pik) -> PikmiRouteItem in
            if let likeBy = pik.likeBy, likeBy.contains(where: { $0.id == UserDefaultsAccess.get(key: .userID) }) {
                if prevLikeByCount != likeBy.count {
                    rank += 1
                }
                prevLikeByCount = likeBy.count
                return .pikmiRoute(.init(state: .init(pik: pik, rank: rank)))
            } else {
                return .pikmiRoute(.init(state: .init(pik: pik, rank: index)))
            }
        }
        
        let pikmiRouteSection = PikmiRouteSectionModel(model: .pikmiRoute(pikmiRouteItems), items: pikmiRouteItems)
        
        return [pikmiRouteSection]
    }
    
    /// RouteItem을 만드는 함수
    /// - Parameter pik: RouteItem에 들어갈 pik
    /// - Returns: RouteItem
    private func makeItem(from pik: Pik) -> RouteItem {
        return .route(.init(state: .init(pik: pik)))
    }
    
    /// RouteSections의 모든 pik을 가져오는 함수
    /// - Parameter sections: 가져올 Routesections
    /// - Returns: sections의 pik list
    private func piks(from sections: [RouteSectionModel]) -> [Pik] {
        var piks: [Pik] = []
        
        for section in sections {
            for item in section.items {
                switch item {
                case let .route(reactor):
                    piks.append(reactor.currentState.pik)
                }
            }
        }
        
        return piks
    }
}
