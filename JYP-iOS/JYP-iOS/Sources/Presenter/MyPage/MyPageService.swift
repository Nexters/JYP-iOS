//
//  MyPageService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/02/11.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import Foundation
import RxSwift
import Foundation

enum MyPageEvent {
    case logout
    case withdraw
}

protocol MyPageServiceType {
    var event: PublishSubject<MyPageEvent> { get }
}

class MyPageService: MyPageServiceType {
    let event = PublishSubject<MyPageEvent>()
    
    func logout() {
        event.onNext(.logout)
    }
    
    func withdraw() {
        event.onNext(.withdraw)
    }
}
