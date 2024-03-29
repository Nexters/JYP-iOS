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
    private let pushTabBarScreen: (() -> TabBarViewController)?

    // MARK: - UI Components

    let onboardingView: UIView = .init()
    let onboardingLogoImageView: UIImageView = .init()
    let onboardinglogoTextImageView: UIImageView = .init()
    let loginLabel: UILabel = .init()
    let kakaoLoginButton: UIButton = .init()
    let appleLoginButton: ASAuthorizationAppleIDButton = .init()
    let indicator: UIActivityIndicatorView = .init(style: .medium)
    
    // MARK: - Initializer

    init(
        reactor: OnboardingSignUpReactor,
        pushOnboardingQuestionJourneyScreen: @escaping () -> OnboardingQuestionJourneyViewController,
        pushTabBarScreen: @escaping () -> TabBarViewController
    ) {
        self.pushOnboardingQuestionJourneyScreen = pushOnboardingQuestionJourneyScreen
        self.pushTabBarScreen = pushTabBarScreen
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
        kakaoLoginButton.imageView?.contentMode = .scaleToFill
        
        appleLoginButton.cornerRound(radius: 6)
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        contentView.addSubviews([onboardingView, loginLabel, kakaoLoginButton, appleLoginButton, indicator])
        onboardingView.addSubviews([onboardingLogoImageView, onboardinglogoTextImageView])
    }

    override func setupLayout() {
        super.setupLayout()

        onboardingView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        onboardingLogoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(152)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(87)
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
        
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func bind(reactor: OnboardingSignUpReactor) {
        kakaoLoginButton.rx.tap
            .bind { [weak self] _ in
                self?.willPresentKakaoLoginScreen { token, name, profileImagePath in
                    self?.reactor?.action.onNext(.login(authVendor: .kakao, token: token, name: name, profileImagePath: profileImagePath))
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
        
        reactor.state
            .compactMap(\.nextScreenType)
            .subscribe(onNext: { [weak self] type in
                switch type {
                case .onboardingQuestionJourney:
                    self?.willPushOnboardingQuestionJourneyViewController()
                    
                case .tabBar:
                    self?.willPresentTabBarViewController()
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isLoading)
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.indicator.startAnimating()
                    self?.view.isUserInteractionEnabled = false
                } else {
                    self?.indicator.stopAnimating()
                    self?.view.isUserInteractionEnabled = true
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Sign Up Methods

extension OnboardingSignUpViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private func willPresentKakaoLoginScreen(completion: @escaping (String, String?, String?) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                guard error == nil, let token = oauthToken?.accessToken else { return }

                UserApi.shared.me { user, _ in
                    let name = user?.properties?["nickname"]
                    let profileImagePath = user?.properties?["profile_image"]

                    completion(token, name, profileImagePath)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                guard error == nil, let token = oauthToken?.accessToken else { return }

                UserApi.shared.me { user, _ in
                    let name = user?.properties?["nickname"]
                    let profileImagePath = user?.properties?["profile_image"]

                    completion(token, name, profileImagePath)
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
            let fullName = appleIDCredential.fullName
            let name = (fullName?.givenName ?? "") + (fullName?.familyName ?? "")

            if let identityToken = appleIDCredential.identityToken,
               let token = String(data: identityToken, encoding: .utf8) {
                reactor?.action.onNext(.login(authVendor: .apple, token: token, name: name, profileImagePath: nil))
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
    private func willPushOnboardingQuestionJourneyViewController() {
        let viewController = pushOnboardingQuestionJourneyScreen()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func willPresentTabBarViewController() {
        if let viewController = pushTabBarScreen?() {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
