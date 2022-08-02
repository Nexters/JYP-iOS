//
//  OnboardingSignUpViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class OnboardingSignUpViewController: NavigationBarViewController, View {
    typealias Reactor = OnboardingSignUpReactor
    
    // MARK: - UI Components
    
    let selfView = OnboardingSignUpView()
    
    // MARK: - Setup Methods
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        setNavigationBarBackgroundColor(JYPIOSAsset.mainPink.color)
        setNavigationBarBackButtonHidden(true)
        setNavigationBarHidden(true)
    }
    
    override func setupProperty() {
        super.setupProperty()
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubview(selfView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        selfView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: OnboardingSignUpReactor) {
        bindActions(to: reactor)
        bindStates(from: reactor)
    }
    
    private func openKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    // do something
                    _ = oauthToken
                    
                    self.reactor?.action.onNext(.didLogin)
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
                    
                    self.reactor?.action.onNext(.didLogin)
                }
            }
        }
    }
    
    private func openAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func presentOnboardingWhatIsTripViewController(reactor: OnboardingWhatIsJourneyReactor) {
        let onboardingWhatIsJourneyViewController = OnboardingWhatIsJourneyViewController()
        onboardingWhatIsJourneyViewController.reactor = reactor
        navigationController?.pushViewController(onboardingWhatIsJourneyViewController, animated: true)
    }
}

// MARK: - Setup Binding Actions

extension OnboardingSignUpViewController {
    func bindActions(to reactor: OnboardingSignUpReactor) {
        bindDidTapKakaoLoginButton(to: reactor)
        bindDidTapAppleLoginButton(to: reactor)
    }
    
    func bindDidTapKakaoLoginButton(to reactor: OnboardingSignUpReactor) {
        selfView.kakaoLoginButton.rx.tap
            .map { .didTapKakaoLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindDidTapAppleLoginButton(to reactor: OnboardingSignUpReactor) {
        selfView.appleLoginButton.rx.tapGesture()
            .filter { $0.state == .ended }
            .map { _ in .didTapAppleLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup Binding States

extension OnboardingSignUpViewController {
    func bindStates(from reactor: OnboardingSignUpReactor) {
        bindIsOpenKakaoLogin(from: reactor)
        bindIsOpenAppleLogin(from: reactor)
        bindIsPresentOnboardingWhatIsTrip(from: reactor)
    }
    
    func bindIsOpenKakaoLogin(from reactor: OnboardingSignUpReactor) {
        reactor.state
            .map { $0.isOpenKakaoLogin }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: openKakaoLogin)
            .disposed(by: disposeBag)
    }
    
    func bindIsOpenAppleLogin(from reactor: OnboardingSignUpReactor) {
        reactor.state
            .map { $0.isOpenAppleLogin }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: openAppleLogin)
            .disposed(by: disposeBag)
    }
    
    func bindIsPresentOnboardingWhatIsTrip(from reactor: OnboardingSignUpReactor) {
        reactor.state
            .map { $0.isPresentOnboardingWhatIsTrip }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in reactor.getOnboardingWhatIsTripReactor() }
            .bind(onNext: presentOnboardingWhatIsTripViewController)
            .disposed(by: disposeBag)
    }
}

extension OnboardingSignUpViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
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

            reactor?.action.onNext(.didLogin)
            
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
