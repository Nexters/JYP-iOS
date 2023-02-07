//
//  JYPTagCollectionViewCellReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class JYPTagCollectionViewCellReactor: Reactor {
    typealias Action = NoAction

    struct State {
        var tag: Tag
        var inActive: Bool
    }
    
    let initialState: State
    
    init(tag: Tag, inActive: Bool) {
        initialState = .init(tag: tag, inActive: inActive)
    }
}
