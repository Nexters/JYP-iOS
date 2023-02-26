//
//  OnboardingView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/17.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

enum OnboardingViewType: CaseIterable {
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
    
    let onboardingContentView: UIView = .init()
    let onboardingTextLogoImageView: UIImageView = .init()
    let subLabel: UILabel = .init()
    let onboardingImageView: UIImageView = .init()
    let stackView: UIStackView = .init()
    let nextButton: JYPButton = .init(type: .next)
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(type: OnboardingViewType) {
        self.type = type
        
        super.init(frame: .zero)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        backgroundColor = .init(hex: 0xF9F9F9)
        
        onboardingContentView.backgroundColor = .white
        onboardingContentView.cornerRound(radius: 40, direct: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner])
        onboardingContentView.setShadow(radius: 5, offset: .init(width: 0, height: 5), opacity: 0.06)
        
        onboardingTextLogoImageView.image = JYPIOSAsset.onboardingTextLogoBlack.image
        
        subLabel.text = type.sub
        subLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 24)
        subLabel.textColor = JYPIOSAsset.textB90.color
        subLabel.numberOfLines = 2
        subLabel.lineSpacing(lineHeight: 36)
        
        onboardingImageView.image = type.onboardingImage
        
        stackView.spacing = 8
        
        for type in OnboardingViewType.allCases {
            let circleView: UIView = .init()

            circleView.snp.makeConstraints {
                $0.size.equalTo(8)
            }
            
            if type == self.type {
                circleView.backgroundColor = JYPIOSAsset.textB80.color
            } else {
                circleView.backgroundColor = .init(hex: 0xDADADA)
            }
            circleView.cornerRound(radius: 4)
            
            stackView.addArrangedSubview(circleView)
        }
        
        nextButton.isEnabled = true
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([onboardingContentView, stackView, nextButton])
        onboardingContentView.addSubviews([onboardingImageView, onboardingTextLogoImageView, subLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        onboardingContentView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(110)
        }
        
        onboardingTextLogoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(24)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(onboardingTextLogoImageView.snp.bottom).offset(48)
            $0.leading.equalToSuperview().inset(24)
        }
        
        onboardingImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(onboardingContentView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(6)
            $0.height.equalTo(52)
        }
    }
}
