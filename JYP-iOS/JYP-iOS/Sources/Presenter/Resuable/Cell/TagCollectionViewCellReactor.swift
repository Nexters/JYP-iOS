//
//  TagCollectionViewCellReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class TagCollectionViewCellReactor: Reactor {
    typealias Action = NoAction

    let initialState: Tag
    
    init(tag: Tag) {
        initialState = tag
    }
}
