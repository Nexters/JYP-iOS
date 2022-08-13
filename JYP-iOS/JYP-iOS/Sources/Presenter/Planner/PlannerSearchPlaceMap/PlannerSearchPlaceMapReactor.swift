//
//  PlannerSearchPlaceMapReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/14.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class PlannerSearchPlaceMapReactor: Reactor {
    enum Action {
        case didTapInfoButton
        case dismiss
    }
    
    enum Mutation {
        case updateIsPresentWebViewController(String?)
        case dismiss
    }
    
    struct State {
        let kakaoSearchPlace: KakaoSearchPlace
        var isPresentWebViewController: String?
        var dismiss: Bool = false
    }
    
    var initialState: State
    
    init(state: State) {
        initialState = state
    }
}

extension PlannerSearchPlaceMapReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        let state = currentState
        
        switch action {
        case .didTapInfoButton:
            return .concat([
                .just(.updateIsPresentWebViewController(state.kakaoSearchPlace.placeURL)),
                .just(.updateIsPresentWebViewController(nil))
            ])
        case .dismiss:
            return .just(.dismiss)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateIsPresentWebViewController(url):
            newState.isPresentWebViewController = url
        case .dismiss:
            newState.dismiss = true
        }
        
        return newState
    }
}
