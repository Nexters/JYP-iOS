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
    // MARK: - Properties
    
    typealias Reactor = OnboardingSignUpReactor
    
    private let pushOnboardingQuestionJourneyScreen: () -> OnboardingQuestionJourneyViewController
    
    // MARK: - UI Components
    
    let onboardingView = UIView()
    let onboardingLogoImageView = UIImageView()
    let onboardinglogoTextImageView = UIImageView()
    let loginLabel = UILabel()
    let kakaoLoginButton = UIButton()
    let appleLoginButton = ASAuthorizationAppleIDButton()
    
    // MARK: - Initializer
    
    init(reactor: OnboardingSignUpReactor,
         pushOnboardingQuestionJourneyScreen: @escaping () -> OnboardingQuestionJourneyViewController) {
        self.pushOnboardingQuestionJourneyScreen = pushOnboardingQuestionJourneyScreen
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            .bind { [weak self] _ in
                self?.willPresentKakaoLoginScreen() { token in
                    self?.reactor?.action.onNext(.login(token))
                }
            }
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tapGesture()
            .when(.recognized)
            .filter { $0.state == .ended }
            .bind { [weak self] _ in
                self?.willPresentAppleLoginScreen()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Sign Up Methods

extension OnboardingSignUpViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private func willPresentKakaoLoginScreen(completion: @escaping (String) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else if let token = oauthToken?.accessToken {
                    completion(token)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else if let token = oauthToken?.accessToken {
                    completion(token)
                }
            }
        }
    }
    
    private func willPresentAppleLoginScreen() {
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
            if let identityToken = appleIDCredential.identityToken,
               let token = String(data: identityToken, encoding: .utf8){
                reactor?.action.onNext(.login(token))
            }
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
}

extension OnboardingSignUpViewController {
    func willPushOnboardingQuestionJourneyViewController() {
        let viewController = pushOnboardingQuestionJourneyScreen()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
