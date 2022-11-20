//
//  UserService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/22.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxSwift

enum UserEvent {
    case user(id: String)
    case editUser(id: String, request: EditUserRequest)
    case createUser(request: CreateUserRequest)
}

protocol UserServiceType {
    var event: PublishSubject<UserEvent> { get }
    
    func user(id: String) -> Observable<BaseModel<User>>
    func editUser(id: String, request: EditUserRequest) -> Observable<BaseModel<User>>
    func createUser(request: CreateUserRequest) -> Observable<BaseModel<User>>
}

class UserService: BaseService, UserServiceType {
    var event = PublishSubject<UserEvent>()
    
    func user(id: String) -> Observable<BaseModel<User>> {
        let target = UserAPI.fetchUser(id: id)
        
        return APIService.request(target: target)
            .map(BaseModel<User>.self)
            .asObservable()
    }
    
    func editUser(id: String, request: EditUserRequest) -> Observable<BaseModel<User>> {
        let target = UserAPI.updateUser(id: id, request: request)
        
        return APIService.request(target: target)
            .map(BaseModel<User>.self)
            .asObservable()
    }
    
    func createUser(request: CreateUserRequest) -> Observable<BaseModel<User>> {
        let target = UserAPI.createUser(request: request)
        
        return APIService.request(target: target)
            .map(BaseModel<User>.self)
            .asObservable()
    }
}
