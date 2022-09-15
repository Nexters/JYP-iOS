//
//  TagBottomSheetReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/07.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class TagBottomSheetReactor: Reactor {
    enum Action {}
    enum Mutation {}
    
    var initialState: Tag
    
    init(tag: Tag) {
        self.initialState = tag
    }
}
