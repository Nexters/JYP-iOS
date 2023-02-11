//
//  MyPageService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/02/11.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import Foundation
import RxSwift

enum MyPageEvent {
    case didLogout
    case didWithdraw
}

protocol MyPageServiceType {
    var event: PublishSubject<MyPageEvent> { get }
}

class MyPageService: MyPageServiceType {
    let event = PublishSubject<MyPageEvent>()
    
    func logout() {
        event.onNext(.didLogout)
    }
    
    func withdraw() {
        event.onNext(.didWithdraw)
    }
}
