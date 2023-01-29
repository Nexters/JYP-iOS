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

class UserService: GlobalService, UserServiceType {
    var event = PublishSubject<UserEvent>()
    
    func fetchUser(id: String) {
        let target = UserAPI.fetchUser(id: id)
        
        let request = APIService.request(target: target)
            .map(BaseModel<User>.self)
            .map { $0.data }
            .asObservable()
        
        request
            .compactMap { $0 }
            .bind { [weak self] user in
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
        
        request
            .compactMap { $0 }
            .bind { [weak self] user in
                self?.event.onNext(.updateUser(user))
            }
            .disposed(by: disposeBag)
    }
    
    func createUser(request: CreateUserRequest) {
        let target = UserAPI.createUser(request: request)
        
        let request = APIService.request(target: target)
            .map(BaseModel<User>.self)
            .asObservable()
        
        request
            .subscribe(onNext: { [weak self] res in
                switch res.code {
                case "20000":
                    if let user = res.data {
                        UserDefaultsAccess.set(key: .userID, value: user.id)
                        self?.event.onNext(.createUser(user))
                    }
                case "50000":
                    //TODO: User 조회 API 가 만들어지면 수정, 우선 User ID 만 넘김
                    let sIndx = res.message.endIndex(of: "_id:")
                    let eIndx = res.message.index(of: "}")
                    if let sIndx = sIndx, let eIndx = eIndx, sIndx < eIndx {
                        var userID = String(describing: res.message[sIndx..<eIndx])
                        userID = userID.replacingOccurrences(of: "\"", with: "")
                        userID = userID.trimmingCharacters(in: .whitespacesAndNewlines)
                        UserDefaultsAccess.set(key: .userID, value: userID)
                        self?.event.onNext(.createUser(User(id: userID, nickname: "테스트 닉네임", profileImagePath: "없음", personality: .FW)))
                    }
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
    }
}
