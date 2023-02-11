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
    case withdraw
}

protocol UserServiceType {
    var event: PublishSubject<UserEvent> { get }
    
    func fetchMe() -> Observable<Any>
    func fetchUser(id: String)
    func updateUser(id: String, request: UpdateUserRequest)
    func createUser(request: CreateUserRequest)
    func deleteUser(id: String)
    
    func login(user: User)
    func logout()
    func withdraw()
}

class UserService: GlobalService, UserServiceType {
    var event = PublishSubject<UserEvent>()
        
    func fetchMe() -> Observable<Any> {
        let target = UserAPI.fetchMe
        
        let request = APIService.request(target: target)
            .map(BaseModel<User>.self)
            .asObservable()
        
        request
            .compactMap(\.data)
            .subscribe(onNext: { [weak self] user in
                self?.login(user: user)
                self?.event.onNext(.fetchMe(user))
            })
            .disposed(by: disposeBag)
        
        return request.flatMap { model -> Observable in
                .create { observer in
                    switch model.code {
                    case "40400": observer.onError(JYPNetworkError.serverError(model.message))
                    default: break
                    }
                    return Disposables.create()
                }
        }
        .asObservable()
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
    
    func deleteUser(id: String) {
        let target = UserAPI.deleteUser(id: id)
        
        let request = APIService.request(target: target)
            .map(EmptyModel.self)
            .asObservable()
        
        request
            .filter({ $0.code == "20000" })
            .bind { [weak self] _ in
                self?.withdraw()
                self?.event.onNext(.deleteUser)
            }
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
    
    func withdraw() {
        UserDefaultsAccess.remove(key: .userID)
        UserDefaultsAccess.remove(key: .accessToken)
        
        event.onNext(.withdraw)
    }
}
