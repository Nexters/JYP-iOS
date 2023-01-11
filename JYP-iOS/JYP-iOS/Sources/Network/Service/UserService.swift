//
//  UserService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/22.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxSwift

enum UserEvent {
    case fetchUser(User)
    case updateUser(User)
    case createUser(User)
}

protocol UserServiceType {
    var event: PublishSubject<UserEvent> { get }
    
    func fetchUser(id: String)
    func updateUser(id: String, request: UpdateUserRequest)
    func createUser(request: CreateUserRequest)
}

class UserService: BaseService, UserServiceType {
    var event = PublishSubject<UserEvent>()
    
    func fetchUser(id: String) {
        let target = UserAPI.fetchUser(id: id)
        
        let request = APIService.request(target: target)
            .map(BaseModel<User>.self)
            .map { $0.data }
            .asObservable()
        
        request.bind { [weak self] user in
            self?.event.onNext(.fetchUser(user))
        }
        .disposed(by: disposeBag)
    }
    
    func updateUser(id: String, request: UpdateUserRequest) {
        let target = UserAPI.updateUser(id: id, request: request)

        let request = APIService.request(target: target)
            .map(BaseModel<User>.self)
            .map { $0.data }
            .asObservable()
        
        request.bind { [weak self] user in
            self?.event.onNext(.updateUser(user))
        }
        .disposed(by: disposeBag)
    }
    
    func createUser(request: CreateUserRequest){
        let target = UserAPI.createUser(request: request)
        
        let request = APIService.request(target: target)
            .map(BaseModel<User>.self)
            .map { $0.data }
            .asObservable()
        
        request.bind { [weak self] user in
            self?.event.onNext(.createUser(user))
        }
        .disposed(by: disposeBag)
    }
}
