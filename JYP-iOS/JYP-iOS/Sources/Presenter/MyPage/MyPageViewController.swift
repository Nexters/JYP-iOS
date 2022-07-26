//
//  MyPageViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/17.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import RxSwift
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class MyPageViewController: BaseViewController {
    let titleLabel = UILabel()
    let appleSignUpButton = ASAuthorizationAppleIDButton()
    let kakaoSignUpButton = UIButton(type: .system)
    let searchPlaceButton = UIButton(type: .system)
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.text = "마이 페이지 뷰컨"
        titleLabel.textColor = .black

        kakaoSignUpButton.setTitle("카카오 로그인 버튼", for: .normal)
        searchPlaceButton.setTitle("장소 검색 뷰컨 이동", for: .normal)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([titleLabel, appleSignUpButton, kakaoSignUpButton, searchPlaceButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        appleSignUpButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        kakaoSignUpButton.snp.makeConstraints {
            $0.top.equalTo(appleSignUpButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        searchPlaceButton.snp.makeConstraints {
            $0.top.equalTo(kakaoSignUpButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
        appleSignUpButton.rx.controlEvent(.touchUpInside)
            .bind { [weak self] in
                self?.appleSignUp()
            }
            .disposed(by: disposeBag)
        
        kakaoSignUpButton.rx.tap
            .bind { [weak self] in
                self?.kakaoSignUp()
            }
            .disposed(by: disposeBag)
        
        searchPlaceButton.rx.tap
            .bind { [weak self] in
                self?.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(SearchPlaceViewController(), animated: true)
            }
            .disposed(by: disposeBag)
    }

    private func appleSignUp() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func kakaoSignUp() {
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    // do something
                    _ = oauthToken
                }
            }
        } else {
            // 카카오 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoAccount() success.")
                    
                    // do something
                    _ = oauthToken
                }
            }
        }
    }
}

extension MyPageViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if let authorizationCode = appleIDCredential.authorizationCode, let identityToken = appleIDCredential.identityToken, let authString = String(data: authorizationCode, encoding: .utf8), let tokenString = String(data: identityToken, encoding: .utf8) {
                print("[D] authorizationCode: \(authorizationCode)")
                print("[D] identityToken: \(identityToken)")
                print("[D] authString: \(authString)")
                print("[D] tokenString: \(tokenString)")
            }
            
            print("[D] useridentifier: \(userIdentifier)")
            print("[D] fullName: \(String(describing: fullName))")
            print("[D] email: \(String(describing: email))")
        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("[D] username: \(username)")
            print("[D] password: \(password)")
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("[D] 애플 로그인 실패")
    }
}
