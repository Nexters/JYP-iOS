//
//  MyPageReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/01/14.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import ReactorKit

class MyPageReactor: Reactor {
    enum Action {
        case logout
    }
    
    enum Mutation { }
    
    struct State { }
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
}

extension MyPageReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .logout:
            UserDefaultsAccess.remove(key: .userID)
            KeychainAccess.remove(key: .accessToken)
            return .empty()
        }
    }
}
