//
//  OnboardingLikingView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/31.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import Then

class OnboardingLikingView: BaseView {
    // MARK: - UI Components
    
    var onboardingView: UIView!
    var titleLabel: UILabel!
    var onboardingLabel: UILabel!
    var nextButton: JYPButton!
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        backgroundColor = JYPIOSAsset.backgroundWhite200.color
        
        onboardingView = .init().then {
            $0.backgroundColor = JYPIOSAsset.backgroundWhite100.color
            // TODO: 아래 왼쪽, 아래 오른쪽 cornerRadius = 40
        }
        
        titleLabel = .init().then {
            $0.text = "Journey piki"
            $0.textColor = JYPIOSAsset.textB75.color
            $0.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        }
        
        onboardingLabel = .init().then {
            $0.text = "나의 여행 취향을\n친구들과 공유하세요!"
            $0.textColor = JYPIOSAsset.textB90.color
            $0.numberOfLines = 2
            $0.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 24)
        }
        
        nextButton = .init(type: .next).then {
            $0.isEnabled = true
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([onboardingView, nextButton])
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(onboardingView.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(6)
            $0.height.equalTo(52)
        }
    }
}
