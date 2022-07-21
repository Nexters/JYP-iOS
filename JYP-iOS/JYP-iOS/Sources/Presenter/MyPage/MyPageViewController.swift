//
//  MyPageViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/17.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import AuthenticationServices

class MyPageViewController: BaseViewController {
    let titleLabel = UILabel()
    let appleSignUpButton = ASAuthorizationAppleIDButton()
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.text = "마이 페이지 뷰컨"
        titleLabel.textColor = .black
        
        appleSignUpButton.addTarget(self, action: #selector(handlerAppleButton), for: .touchUpInside)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubview(titleLabel)
        view.addSubview(appleSignUpButton)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        appleSignUpButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-10)
            $0.centerX.equalToSuperview()
        }
    }
    
    @objc
    private func handlerAppleButton() {
        openAppleSignUpView()
    }
    
    private func openAppleSignUpView() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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
