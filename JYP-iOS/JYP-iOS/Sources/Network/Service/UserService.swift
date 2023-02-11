//
//  UserService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/22.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxSwift

enum UserEvent {
    case fetchMe(User)
    case fetchUser(User)
    case updateUser(User)
    case createUser(User)
    case deleteUser
    case error(JYPNetworkError)
    
    case login
    case logout
}

protocol UserServiceType {
    var event: PublishSubject<UserEvent> { get }
    
    func fetchMe()
    func fetchUser(id: String)
    func updateUser(id: String, request: UpdateUserRequest)
    func createUser(request: CreateUserRequest)
    
    func login(user: User)
    func logout()
}

class UserService: GlobalService, UserServiceType {
    var event = PublishSubject<UserEvent>()
        
    func fetchMe() {
        let target = UserAPI.fetchMe
        
        let request = APIService.request(target: target)
            .map(BaseModel<User>.self)
            .compactMap(\.data)
            .asObservable()
        
        request
            .subscribe(onNext: { [weak self] user in
                self?.login(user: user)
                self?.event.onNext(.fetchMe(user))
            })
            .disposed(by: disposeBag)
    }
    
    func fetchUser(id: String) {
        let target = UserAPI.fetchUser(id: id)
        
        let request = APIService.request(target: target)
            .map(BaseModel<User>.self)
            .compactMap(\.data)
            .asObservable()
        
        request
            .subscribe(onNext: { [weak self] user in
                self?.login(user: user)
                self?.event.onNext(.fetchUser(user))
            })
            .disposed(by: disposeBag)
    }
    
    func updateUser(id: String, request: UpdateUserRequest) {
        let target = UserAPI.updateUser(id: id, request: request)

        let request = APIService.request(target: target)
            .map(BaseModel<User>.self)
            .asObservable()
        
        request
            .compactMap(\.data)
            .subscribe(onNext: { [weak self] user in
                self?.login(user: user)
                self?.event.onNext(.updateUser(user))
            })
            .disposed(by: disposeBag)
    }
    
    func createUser(request: CreateUserRequest) {
        let target = UserAPI.createUser(request: request)
        
        let request = APIService.request(target: target)
            .map(BaseModel<User>.self)
            .compactMap(\.data)
            .asObservable()
        
        request
            .subscribe(onNext: { [weak self] user in
                self?.login(user: user)
                self?.event.onNext(.createUser(user))
            })
            .disposed(by: disposeBag)
    }
    
    func login(user: User) {
        UserDefaultsAccess.set(key: .userID, value: user.id)
        UserDefaultsAccess.set(key: .nickname, value: user.nickname)
        UserDefaultsAccess.set(key: .personality, value: user.personality.title)
        
        event.onNext(.login)
    }
    
    func logout() {
        UserDefaultsAccess.remove(key: .userID)
        UserDefaultsAccess.remove(key: .accessToken)
        
        event.onNext(.logout)
    }
}
