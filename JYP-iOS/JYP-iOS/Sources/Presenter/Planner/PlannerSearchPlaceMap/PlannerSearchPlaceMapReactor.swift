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
        case updateWebReactor(WebReactor?)
        case updateIsDismiss(Bool)
    }
    
    struct State {
        let kakaoSearchPlace: KakaoSearchPlace
        var webReactor: WebReactor?
        var isDismiss: Bool = false
    }
    
    var initialState: State
    
    init(state: State) {
        initialState = state
    }
}

extension PlannerSearchPlaceMapReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapInfoButton:
            return mutateDidTapInfoButton()
        case .dismiss:
            return mutateDismiss()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateWebReactor(reactor):
            newState.webReactor = reactor
        case let .updateIsDismiss(bool):
            newState.isDismiss = bool
        }
        
        return newState
    }
    
    private func mutateDidTapInfoButton() -> Observable<Mutation> {
        let state = currentState
        
        return .concat([
            .just(.updateWebReactor(WebReactor(state: .init(url: state.kakaoSearchPlace.placeURL)))),
            .just(.updateWebReactor(nil))
        ])
    }
    
    private func mutateDismiss() -> Observable<Mutation> {
        return .just(.updateIsDismiss(true))
    }
}
