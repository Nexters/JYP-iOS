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
    
    let onboardingView = UIView()
    let onboardingLogoImageView = UIImageView()
    let onboardinglogoTextImageView = UIImageView()
    let loginLabel = UILabel()
    let kakaoLoginButton = UIButton()
    let appleLoginButton = ASAuthorizationAppleIDButton()
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(reactor: OnboardingSignUpReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    // MARK: - Setup Methods
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        setNavigationBarBackgroundColor(JYPIOSAsset.mainPink.color)
        setNavigationBarBackButtonHidden(true)
        setNavigationBarHidden(true)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        view.backgroundColor = JYPIOSAsset.backgroundWhite100.color
        
        onboardingView.backgroundColor = JYPIOSAsset.mainPink.color
        onboardingView.cornerRound(radius: 40, direct: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        
        onboardingLogoImageView.image = JYPIOSAsset.onboardingLogo.image
        
        onboardinglogoTextImageView.image = JYPIOSAsset.onboardingTextLogoWhite.image
        
        loginLabel.text = "SNS 계정으로 회원가입 및 로그인"
        loginLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
        loginLabel.textColor = JYPIOSAsset.textB40.color

        kakaoLoginButton.setBackgroundImage(JYPIOSAsset.kakaoLogin.image, for: .normal)
        
        appleLoginButton.cornerRound(radius: 6)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([onboardingView, loginLabel, kakaoLoginButton, appleLoginButton])
        onboardingView.addSubviews([onboardingLogoImageView, onboardinglogoTextImageView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        onboardingView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        onboardingLogoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(152)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(87)
        }
        
        onboardinglogoTextImageView.snp.makeConstraints {
            $0.top.equalTo(onboardingLogoImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        loginLabel.snp.makeConstraints {
            $0.top.equalTo(onboardingView.snp.bottom).offset(71)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(kakaoLoginButton.snp.top).offset(-19)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(-13)
            $0.height.equalTo(50)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.height.equalTo(50)
        }
    }
    
    func bind(reactor: OnboardingSignUpReactor) {
        kakaoLoginButton.rx.tap
            .map { .didTapKakaoLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tapGesture()
            .filter { $0.state == .ended }
            .map { _ in .didTapAppleLoginButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isOpenKakaoLogin }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: openKakaoLogin)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isOpenAppleLogin }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
            .bind(onNext: openAppleLogin)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap(\.onboardingQuestionReactor)
            .withUnretained(self)
            .bind { this, reactor in
                let onboardingQuestionJourneyViewController = OnboardingQuestionJourneyViewController(reactor: reactor)
                
                this.navigationController?.pushViewController(onboardingQuestionJourneyViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Sign Up Methods

extension OnboardingSignUpViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private func openKakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    UserApi.shared.me { (user, _) in
                        if let error = error {
                            print(error)
                        } else {
                            self.reactor?.action.onNext(.didLogin(authVendor: .kakao, authId: oauthToken?.accessToken ?? "", name: user?.properties?["nickname"] ?? "", profileImagePath: user?.properties?["profile_image"] ?? ""))
                        }
                    }
                }
            }
        } else {
            // 카카오 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("loginWithKakaoAccount() success.")
                    
                    UserApi.shared.me { (user, _) in
                        if let error = error {
                            print(error)
                        } else {
                            self.reactor?.action.onNext(.didLogin(authVendor: .kakao, authId: oauthToken?.accessToken ?? "", name: user?.properties?["nickname"] ?? "", profileImagePath: user?.properties?["profile_image"] ?? ""))
                        }
                    }
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
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let fullName = appleIDCredential.fullName
            
            if let identityToken = appleIDCredential.identityToken,
                let tokenString = String(data: identityToken, encoding: .utf8) {
                self.reactor?.action.onNext(.didLogin(authVendor: .apple, authId: tokenString, name: String(describing: fullName), profileImagePath: ""))
            }
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}
