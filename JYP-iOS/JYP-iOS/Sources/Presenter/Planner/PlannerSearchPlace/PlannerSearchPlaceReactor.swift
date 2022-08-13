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
        case tapKakaoSearchPlaceCell(IndexPath)
        case dismiss
    }
    
    enum Mutation {
        case updatekakaoSearchPlacePresentPlannerSearchPlaceMapViewController(KakaoSearchPlace)
        case setSections([PlannerSearchPlaceSectionModel])
        case dismiss
    }
    
    struct State {
        var sections: [PlannerSearchPlaceSectionModel]
        var kakaoSearchPlacePresentPlannerSearchPlaceMapViewController: KakaoSearchPlace?
        var dismiss: Bool = false
    }
    
    let provider: ServiceProviderType
    var initialState: State
    
    init(provider: ServiceProviderType) {
        self.provider = provider
        initialState = State(sections: [])
    }
}

extension PlannerSearchPlaceReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        let state = currentState
        
        switch action {
        case let .search(keyword):
            return provider.kakaoSearchService.searchPlace(keyword: keyword, page: 1)
                .map { kakaoSearchResponse in
                    let kakaoSearchItems = kakaoSearchResponse.kakaoSearchPlaces.map { (kakaoSearchPlace) -> PlannerSearchPlaceItem in
                        return .kakaoItem(KakaoSearchPlaceTableViewCellReactor(kakaoSearchPlace: kakaoSearchPlace))
                    }
                    let kakaoSearchSection = PlannerSearchPlaceSectionModel(model: .kakaoSection(kakaoSearchItems), items: kakaoSearchItems)
                    
                    return .setSections([kakaoSearchSection])
            }
        case let .tapKakaoSearchPlaceCell(indexPath):
            guard case let .kakaoItem(reactor) = state.sections[indexPath.section].items[indexPath.row] else { break }
            let kakaoSearchPlace = reactor.currentState

            return .just(.updatekakaoSearchPlacePresentPlannerSearchPlaceMapViewController(kakaoSearchPlace))
        case .dismiss:
            return .just(.dismiss)
        }
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setSections(plannerSearchPlaceSectionModels):
            newState.sections = plannerSearchPlaceSectionModels
        case let .updatekakaoSearchPlacePresentPlannerSearchPlaceMapViewController(kakaoSearchPlace):
            newState.kakaoSearchPlacePresentPlannerSearchPlaceMapViewController = kakaoSearchPlace
        case .dismiss:
            newState.dismiss = true
        }
        
        return newState
    }
}
