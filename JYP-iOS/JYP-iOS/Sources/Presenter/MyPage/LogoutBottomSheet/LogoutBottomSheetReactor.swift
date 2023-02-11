//
//  LogoutBottomSheetReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/02/11.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import ReactorKit

class LogoutBottomSheetReactor: Reactor {
    enum Action {
        case tapLogoutButton
    }
    
    enum Mutation {
    }
    
    struct State {
        
    }
    
    var initialState: State
    
    let userService: UserServiceType
    
    init(userService: UserServiceType) {
        self.userService = userService
        self.initialState = .init()
    }
}

extension LogoutBottomSheetReactor {

}
