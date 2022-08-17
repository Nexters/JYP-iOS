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
    
    var onboardingView = UIView()
    var titleLabel = UILabel()
    var onboardingLabel = UILabel()
    var loginLabel = UILabel()
    var kakaoLoginButton = UIButton()
    var appleLoginButton = ASAuthorizationAppleIDButton()
    
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
        
        titleLabel.text = "친구들과\n만들어나가는 여행"
        titleLabel.textColor = JYPIOSAsset.textWhite.color
        titleLabel.numberOfLines = 2
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 24)
        
        onboardingLabel.text = "저니 피키"
        onboardingLabel.textColor = JYPIOSAsset.textWhite.color
        onboardingLabel.numberOfLines = 2
        onboardingLabel.font = JYPIOSFontFamily.Pretendard.bold.font(size: 24)

        loginLabel.text = "SNS 계정으로 회원가입 및 로그인"
        loginLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        loginLabel.textColor = JYPIOSAsset.textB75.color

        kakaoLoginButton.setBackgroundImage(JYPIOSAsset.kakaoLogin.image, for: .normal)
        
        appleLoginButton.cornerRound(radius: 6)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([onboardingView, loginLabel, kakaoLoginButton, appleLoginButton])
        onboardingView.addSubviews([titleLabel, onboardingLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        onboardingView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(24)
        }
        
        onboardingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(35)
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
            .map { $0.isPresentOnboardingWhatIsTrip }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in reactor.getOnboardingWhatIsTripReactor() }
            .bind(onNext: presentOnboardingWhatIsTripViewController)
            .disposed(by: disposeBag)
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
