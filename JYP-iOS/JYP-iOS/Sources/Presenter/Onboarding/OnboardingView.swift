//
//  OnboardingView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/17.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

enum OnboardingViewType {
    case one
    case two
    
    var sub: String {
        switch self {
        case .one:
            return "나의 여행 취향을\n친구들과 공유하세요!"
        case .two:
            return "친구들과 방문할\n여행 장소를 선정하세요!"
        }
    }
    
    var onboardingImage: UIImage {
        switch self {
        case .one:
            return JYPIOSAsset.onboardingCardOne.image
        case .two:
            return JYPIOSAsset.onboardingCardTwo.image
        }
    }
}

class OnboardingView: BaseView {
    let type: OnboardingViewType
    
    let serviceNameImageView = UIImageView()
    let subLabel = UILabel()
    let onboardingImageView = UIImageView()
    let nextButton = JYPButton(type: .next)
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(type: OnboardingViewType) {
        self.type = type
        
        super.init(frame: .zero)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        serviceNameImageView.image = JYPIOSAsset.onboardingTextLogoWhite.image
        
        subLabel.text = type.sub
        subLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 24)
        subLabel.textColor = JYPIOSAsset.textB90.color
        subLabel.numberOfLines = 2
        
        onboardingImageView.image = type.onboardingImage
        onboardingImageView.cornerRound(radius: 40, direct: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        
        nextButton.isEnabled = true
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([serviceNameImageView, subLabel, onboardingImageView, nextButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        serviceNameImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(99)
            $0.height.equalTo(24)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(serviceNameImageView.snp.bottom).offset(48)
            $0.leading.equalToSuperview().inset(24)
        }
        
        onboardingImageView.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(35)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(442)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(52)
        }
    }
}
