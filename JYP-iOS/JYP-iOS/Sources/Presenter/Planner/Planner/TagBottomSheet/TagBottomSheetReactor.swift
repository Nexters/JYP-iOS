//
//  TagBottomSheetReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/07.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class TagBottomSheetReactor: Reactor {
    enum Action {
        case tapOkButton
    }
    
    enum Mutation {
        case updateIsDismiss(Bool)
    }
    
    struct State {
        let tag: Tag
        var isDimiss: Bool = false
    }
    
    var initialState: State
    
    init(tag: Tag) {
        self.initialState = State(tag: tag)
    }
}

extension TagBottomSheetReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapOkButton:
            return .just(.updateIsDismiss(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateIsDismiss(bool):
            newState.isDimiss = bool
        }
        
        return newState
    }
}
