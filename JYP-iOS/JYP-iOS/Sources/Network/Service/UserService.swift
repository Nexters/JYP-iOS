//
//  UserService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/22.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxSwift

enum UserEvent {
    case search(Int)
    case update(Int, UserUpdateRequest)
    case signup(SignupRequest)
}

protocol UserServiceType {
    var event: PublishSubject<UserEvent> { get }
    
    func search(id: Int) -> Observable<User>
    func update(id: Int, request: UserUpdateRequest) -> Observable<User>
    func signup(request: SignupRequest) -> Observable<BaseModel<User>>
}

class UserService: BaseService, UserServiceType {
    var event = PublishSubject<UserEvent>()
    
    func search(id: Int) -> Observable<User> {
        let target = UserAPI.search(id: id)
        
        return APIService.request(target: target)
            .map(User.self)
            .asObservable()
    }
    
    func update(id: Int, request: UserUpdateRequest) -> Observable<User> {
        let target = UserAPI.update(id: id, request: request)
        
        return APIService.request(target: target)
            .map(User.self)
            .asObservable()
    }
    
    func signup(request: SignupRequest) -> Observable<BaseModel<User>> {
        let target = UserAPI.signup(request: request)
        
        return APIService.request(target: target)
            .map(BaseModel<User>.self)
            .asObservable()
    }
}
