//
//  OnboardingSignUpView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import AuthenticationServices

class OnboardingSignUpView: BaseView {
    // MARK: - UI Components
    
    var onboardingView: UIView!
    var titleLabel: UILabel!
    var onboardingLabel: UILabel!
    var loginLabel: UILabel!
    var kakaoLoginButton: UIButton!
    var appleLoginButton: ASAuthorizationAppleIDButton!
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        backgroundColor = JYPIOSAsset.backgroundWhite100.color
        
        onboardingView = .init().then {
            $0.backgroundColor = JYPIOSAsset.mainPink.color
            $0.cornerRound(radius: 40, direct: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        }
        
        titleLabel = .init().then {
            $0.text = "친구들과\n만들어나가는 여행"
            $0.textColor = JYPIOSAsset.textWhite.color
            $0.numberOfLines = 2
            $0.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 24)
        }
        
        onboardingLabel = .init().then {
            $0.text = "저니 피키"
            $0.textColor = JYPIOSAsset.textWhite.color
            $0.numberOfLines = 2
            $0.font = JYPIOSFontFamily.Pretendard.bold.font(size: 24)
        }
        
        loginLabel = .init().then {
            $0.text = "SNS 계정으로 회원가입 및 로그인"
            $0.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
            $0.textColor = JYPIOSAsset.textB75.color
        }
        
        kakaoLoginButton = .init().then {
            $0.setBackgroundImage(JYPIOSAsset.kakaoLogin.image, for: .normal)
        }
        
        appleLoginButton = .init().then {
            $0.cornerRound(radius: 6)
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([onboardingView, loginLabel, kakaoLoginButton, appleLoginButton])
        onboardingView.addSubviews([titleLabel, onboardingLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        onboardingView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
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
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(50)
        }
    }
}
