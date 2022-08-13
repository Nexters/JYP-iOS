//
//  PlannerSearchPlaceReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/13.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class PlannerSearchPlaceReactor: Reactor {
    enum Action {
        case search(String)
    }
    
    enum Mutation {
        case setSections([PlannerSearchPlaceSectionModel])
    }
    
    struct State {
        var sections: [PlannerSearchPlaceSectionModel]
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setSections(plannerSearchPlaceSectionModels):
            newState.sections = plannerSearchPlaceSectionModels
        }
        
        return newState
    }
}
