//
//  WebReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/13.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class WebReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
        var url: String
        var navigationBarHidden: Bool
    }
    
    var initialState: State
    
    init(url: String, navigationBarHidden: Bool = true) {
        initialState = State(url: url, navigationBarHidden: navigationBarHidden)
    }
}
