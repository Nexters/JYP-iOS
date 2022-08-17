//
//  CandidatePlaceCollectionViewCellReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class CandidatePlaceCollectionViewCellReactor: Reactor {
    enum Action {
        case animated
    }
    
    enum Mutation {
        case updateIsReadyAnimate(Bool)
    }
    
    struct State {
        var candidatePlace: CandidatePlace
        var rank: Int
        var isSelectedLikeButton: Bool = false
        var isReadyAnimate: Bool = false
    }
    
    let initialState: State
    
    init(state: State) {
        initialState = state
    }
}

extension CandidatePlaceCollectionViewCellReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .animated:
            return .just(.updateIsReadyAnimate(false))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateIsReadyAnimate(bool):
            newState.isReadyAnimate = bool
        }
        
        return newState
    }
}
