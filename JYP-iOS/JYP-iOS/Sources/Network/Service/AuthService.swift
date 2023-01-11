//
//  AuthService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/01/10.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import RxSwift

enum AuthEvent {
    case appleLogin(AppleLoginResponse)
    case kakaoLogin(KakaoLoginResponse)
}

protocol AuthServiceType {
    var event: PublishSubject<AuthEvent> { get }

    func appleLogin()
    func kakaoLogin()
}

final class AuthService: GlobalService, AuthServiceType {
    let event = PublishSubject<AuthEvent>()
    
    func appleLogin() {
        let target = AuthAPI.apple
        
        let request = APIService.request(target: target)
            .map(BaseModel<AppleLoginResponse>.self)
            .map(\.data)
            .asObservable()

        request.subscribe { [weak self] res in
            self?.event.onNext(.appleLogin(res))
        }
        .disposed(by: disposeBag)
    }
    
    func kakaoLogin() {
        let target = AuthAPI.kakao
        
        let request = APIService.request(target: target)
            .map(BaseModel<KakaoLoginResponse>.self)
            .map(\.data)
            .asObservable()

        request.subscribe { [weak self] res in
            self?.event.onNext(.kakaoLogin(res))
        }
        .disposed(by: disposeBag)
    }
}
