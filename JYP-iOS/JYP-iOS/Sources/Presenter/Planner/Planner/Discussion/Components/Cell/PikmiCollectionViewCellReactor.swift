//
//  CandidatePlaceCollectionViewCellReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class PikmiCollectionViewCellReactor: Reactor {
    enum Action {
        case tapLikeButton
    }
    
    enum Mutation {
        case toggle
    }
    
    struct State {
        let rank: Int
        let pik: Pik
        var isSelected: Bool
    }
    
    let initialState: State
    
    init(rank: Int, pik: Pik) {
        let userID = UserDefaultsAccess.get(key: .userID)
        let isSelected = pik.likeBy?.contains(where: { $0.id == userID }) == true
        
        initialState = .init(rank: rank, pik: pik, isSelected: isSelected)
    }
}

extension PikmiCollectionViewCellReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapLikeButton: return .just(.toggle)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .toggle: newState.isSelected.toggle()
        }
        
        return newState
    }
}
