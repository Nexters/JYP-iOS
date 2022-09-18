//
//  PlannerSearchPlaceReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/13.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class PlannerSearchPlaceReactor: Reactor {
    enum Action {
        case search(String)
        case selectCell(IndexPath)
    }
    
    enum Mutation {
        case setSections([PlannerSearchPlaceSectionModel])
        case updatePlannerSearchPlaceMapReactor(PlannerSearchPlaceMapReactor?)
        case updateEmptyViewState(EmptyViewState)
    }
    
    enum EmptyViewState {
        case empty
        case noResult
        case none
    }
    
    struct State {
        var sections: [PlannerSearchPlaceSectionModel] = []
        var plannerSearchPlaceMapReactor: PlannerSearchPlaceMapReactor?
        var emptyViewState: EmptyViewState = .empty
    }
    
    let provider = ServiceProvider.shared
    var initialState: State
    
    init() {
        initialState = State()
    }
}

extension PlannerSearchPlaceReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .search(keyword):
            return mutateSearch(keyword)
        case let .selectCell(indexPath):
            return mutateSelectCell(indexPath)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setSections(plannerSearchPlaceSectionModels):
            newState.sections = plannerSearchPlaceSectionModels
        case let .updatePlannerSearchPlaceMapReactor(reactor):
            newState.plannerSearchPlaceMapReactor = reactor
        case let .updateEmptyViewState(state):
            newState.emptyViewState = state
        }
        
        return newState
    }
    
    private func mutateSearch(_ keyword: String) -> Observable<Mutation> {
        var emptyView: Observable<Mutation> = .just(.updateEmptyViewState(.none))
        
        if keyword.isEmpty {
            emptyView = .just(.updateEmptyViewState(.empty))
        }
        
        let search: Observable<Mutation> = provider.kakaoSearchService.searchPlace(keyword: keyword, page: 1)
            .map { response in
                let items = response.kakaoSearchPlaces.map { (kakaoSearchPlace) -> PlannerSearchPlaceItem in
                    return .kakaoItem(KakaoSearchPlaceTableViewCellReactor(kakaoSearchPlace: kakaoSearchPlace))
                }
                let section = PlannerSearchPlaceSectionModel.init(model: .kakaoSection(items), items: items)
                
                print("[D] \(items)")
                
                if items.isEmpty {
                    emptyView = .just(.updateEmptyViewState(.noResult))
                }
                
                return .setSections([section])
            }
        return .concat([emptyView, search])
    }
    
    private func mutateSelectCell(_ indexPath: IndexPath) -> Observable<Mutation> {
        guard case let .kakaoItem(reactor) =  currentState.sections[indexPath.section].items[indexPath.row] else { return .empty() }
        
        return .concat([
            .just(.updatePlannerSearchPlaceMapReactor(makeReactor(from: reactor))),
            .just(.updatePlannerSearchPlaceMapReactor(nil))
        ])
    }
    
    private func makeReactor(from reactor: KakaoSearchPlaceTableViewCellReactor) -> PlannerSearchPlaceMapReactor {
        return .init(state: .init(kakaoSearchPlace: reactor.currentState))
    }
}
