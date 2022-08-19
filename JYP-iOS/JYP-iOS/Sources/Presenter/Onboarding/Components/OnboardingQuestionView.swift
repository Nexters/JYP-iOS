//
//  OnboardingQuestionView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

enum OnboardingQuestionViewType {
    case journey
    case place
    case plan
    
    var titleText: String {
        switch self {
        case .journey:
            return "본인이 생각하는 여행이란\n무엇인가요?"
        case .place:
            return "여행 중, 새로운 장소를 발견하면\n어떤 선택을 하실 건가요?"
        case .plan:
            return "여행 계획을 세울 때,\n어떤 모습이신가요?"
        }
    }
    
    var cardViewTypeA: OnboardingCardViewType {
        switch self {
        case .journey:
            return .journeyA
        case .place:
            return .placeA
        case .plan:
            return .planA
        }
    }
    
    var cardViewTypeB: OnboardingCardViewType {
        switch self {
        case .journey:
            return .journeyB
        case .place:
            return .placeB
        case .plan:
            return .planB
        }
    }
}

class OnboardingQuestionView: BaseView {
    let type: OnboardingQuestionViewType
    
    let questionIcon = UIImageView()
    let titleLabel = UILabel()
    lazy var onboardingCardViewA = OnboardingCardView(type: type.cardViewTypeA)
    lazy var onboardingCardViewB = OnboardingCardView(type: type.cardViewTypeB)
    let nextButton = JYPButton(type: .next)
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(type: OnboardingQuestionViewType) {
        self.type = type
        super.init(frame: .zero)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        questionIcon.image = JYPIOSAsset.iconQuestion.image

        titleLabel.textColor = JYPIOSAsset.textB90.color
        titleLabel.text = type.titleText
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 24)
        titleLabel.numberOfLines = 2
        
        nextButton.isEnabled = false
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([questionIcon, titleLabel, onboardingCardViewA, onboardingCardViewB, nextButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        questionIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(questionIcon.snp.bottom).offset(4)
            $0.leading.equalTo(questionIcon)
        }
        
        onboardingCardViewA.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(onboardingCardViewB.snp.top).offset(-12)
            $0.height.equalTo(180)
        }
        
        onboardingCardViewB.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(nextButton.snp.top).offset(-74)
            $0.height.equalTo(180)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(6)
            $0.height.equalTo(52)
        }
    }
}
