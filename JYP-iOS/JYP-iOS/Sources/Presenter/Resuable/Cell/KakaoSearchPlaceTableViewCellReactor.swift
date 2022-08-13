//
//  PlaceSearchPlaceTableViewCellReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/13.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class KakaoSearchPlaceTableViewCellReactor: Reactor {
    typealias Action = NoAction
    
    var initialState: KakaoSearchPlace
    
    init(kakaoSearchPlace: KakaoSearchPlace) {
        initialState = kakaoSearchPlace
    }
}
