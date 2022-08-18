//
//  OnboardingCardView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

enum OnboardingCardViewType {
    case journeyA
    case journeyB
    case placeA
    case placeB
    case planA
    case planB
    
    var config: OnboardingCardViewConfig {
        switch self {
        case .journeyA:
            return .init(titleText: "새롭고 많은 것들을\n경험하는 것이라고 생각해요", image: JYPIOSAsset.onboardingQuestionJourneyA.image)
        case .journeyB:
            return .init(titleText: "여유롭게 휴식하는 것이라고\n생각해요", image: JYPIOSAsset.onboardingQuestionJourneyB.image)
        case .placeA:
            return .init(titleText: "미리 세운 계획에\n영향이 간다면 방문하지 않아요", image: JYPIOSAsset.onboardingQuestionPlaceA.image)
        case .placeB:
            return .init(titleText: "궁금증을 참지 못하고\n무조건 방문해요", image: JYPIOSAsset.onboardingQuestionPlaceB.image)
        case .planA:
            return .init(titleText: "시간 단위로 꼼꼼하게\n계획해요", image: JYPIOSAsset.onboardingQuestionPlanA.image)
        case .planB:
            return .init(titleText: "방문할 지역만 대략 생각하고,\n나의 직관을 믿어요", image: JYPIOSAsset.onboardingQuestionPlanB.image)
        }
    }
}

enum OnboardingCardViewState {
    case defualt
    case active
    case inactive
}

struct OnboardingCardViewConfig {
    let titleText: String
    let image: UIImage
}

class OnboardingCardView: BaseView {
    let type: OnboardingCardViewType
    
    var titleLabel = UILabel()
    var badgeImage = UIImageView()
    var circleImage = UIImageView()
    
    var state: OnboardingCardViewState = .defualt {
        didSet {
            switch state {
            case .defualt:
                titleLabel.textColor = JYPIOSAsset.textB80.color
                circleImage.alpha = 1
                badgeImage.isHidden = true
            case .active:
                titleLabel.textColor = JYPIOSAsset.textB80.color
                circleImage.alpha = 1
                badgeImage.isHidden = false
            case .inactive:
                titleLabel.textColor = JYPIOSAsset.textB40.color
                circleImage.alpha = 0.4
                badgeImage.isHidden = true
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(type: OnboardingCardViewType) {
        self.type = type
        
        super.init(frame: .zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setShadow(radius: 20, offset: CGSize(width: 0, height: 5), opacity: 15, color: JYPIOSAsset.backgroundWhite200.color)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        backgroundColor = JYPIOSAsset.backgroundWhite100.color

        cornerRound(radius: 16)

        titleLabel.text = type.config.titleText
        titleLabel.textColor = JYPIOSAsset.textB80.color
        titleLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        titleLabel.numberOfLines = 2
        
        badgeImage.image = JYPIOSAsset.iconCheck.image
        badgeImage.isHidden = true

        circleImage.image = type.config.image
        circleImage.cornerRound(radius: 45)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([titleLabel, badgeImage, circleImage])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(20)
        }
        
        badgeImage.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(40)
        }
        
        circleImage.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(90)
        }
    }
}
