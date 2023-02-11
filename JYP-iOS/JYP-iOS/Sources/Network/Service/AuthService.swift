//
//  AuthService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/01/10.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import RxSwift

enum AuthEvent {
    case apple(AppleLoginResponse)
    case kakao(KakaoLoginResponse)
    
    case authorize
}

protocol AuthServiceType {
    var event: PublishSubject<AuthEvent> { get }

    func apple(token: String)
    func kakao(token: String)
    
    func authorize(token: String)
}

final class AuthService: GlobalService, AuthServiceType {
    let event = PublishSubject<AuthEvent>()
    
    func apple(token: String) {
        let target = AuthAPI.apple(token: token)
        
        let request = APIService.request(target: target)
            .map(BaseModel<AppleLoginResponse>.self)
            .map(\.data)
            .asObservable()

        request
            .compactMap { $0 }
            .subscribe { [weak self] res in
                self?.authorize(token: res.token)
                self?.event.onNext(.apple(res))
            }
            .disposed(by: disposeBag)
    }
    
    func kakao(token: String) {
        let target = AuthAPI.kakao(token: token)
        
        let request = APIService.request(target: target)
            .map(BaseModel<KakaoLoginResponse>.self)
            .map(\.data)
            .asObservable()

        request
            .compactMap { $0 }
            .subscribe { [weak self] res in
                self?.authorize(token: res.token)
                self?.event.onNext(.kakao(res))
            }
            .disposed(by: disposeBag)
    }
    
    func authorize(token: String) {
        UserDefaultsAccess.set(key: .accessToken, value: token)
    }
}
