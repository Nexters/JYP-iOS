//
//  JourneyPlanReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/18.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class JourneyPlanReactor: Reactor {
    enum Action {}
    enum Mutation {}
    
    struct State {
        var sections: [JourneyPlanSectionModel]
    }
    
    let provider = ServiceProvider.shared
    var initialState: State
    
    init() {
        initialState = .init(sections: [])
    }
}
