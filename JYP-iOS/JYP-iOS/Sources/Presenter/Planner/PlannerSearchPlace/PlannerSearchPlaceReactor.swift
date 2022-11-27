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
        var id: String
        var sections: [PlannerSearchPlaceSectionModel] = []
        var plannerSearchPlaceMapReactor: PlannerSearchPlaceMapReactor?
        var emptyViewState: EmptyViewState = .empty
    }
    
    let provider = ServiceProvider.shared
    var initialState: State
    
    init(id: String) {
        self.initialState = State(id: id)
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
        var emptyView: Observable<Mutation>
        var search: Observable<Mutation>
        
        if keyword.isEmpty {
            emptyView = .just(.updateEmptyViewState(.empty))
            search = .just(.setSections([]))
            
            return .concat([emptyView, search])
        } else {
            emptyView = .just(.updateEmptyViewState(.none))
        }
        
        search = Observable<Mutation>.create { [weak self] observer in
            self?.provider.kakaoSearchService.searchPlace(keyword: keyword, page: 1)
                .bind { response in
                    let items = response.kakaoSearchPlaces.map { (kakaoSearchPlace) -> PlannerSearchPlaceItem in
                        return .kakaoItem(KakaoSearchPlaceTableViewCellReactor(kakaoSearchPlace: kakaoSearchPlace))
                    }
                    let section = PlannerSearchPlaceSectionModel.init(model: .kakaoSection(items), items: items)

                    if items.isEmpty {
                        observer.onNext(.updateEmptyViewState(.noResult))
                        observer.onNext(.setSections([]))
                    } else {
                        observer.onNext(.setSections([section]))
                    }
                    observer.onCompleted()
                }
            
            return Disposables.create()
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
        return .init(id: currentState.id, kakaoSearchPlace: reactor.currentState)
    }
}
