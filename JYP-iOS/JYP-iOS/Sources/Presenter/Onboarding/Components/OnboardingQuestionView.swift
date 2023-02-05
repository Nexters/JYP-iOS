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
            return .journeyFirst
        case .place:
            return .placeFirst
        case .plan:
            return .planFirst
        }
    }
    
    var cardViewTypeB: OnboardingCardViewType {
        switch self {
        case .journey:
            return .journeySecond
        case .place:
            return .placeSecond
        case .plan:
            return .planSecond
        }
    }
}

class OnboardingQuestionView: BaseView {
    let type: OnboardingQuestionViewType
    
    let questionIcon: UIImageView = .init()
    let titleLabel: UILabel = .init()
    let nextButton: JYPButton = .init(type: .next)
    
    lazy var firstView: OnboardingCardView = .init(type: type.cardViewTypeA)
    lazy var secondView: OnboardingCardView = .init(type: type.cardViewTypeB)
    
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
        titleLabel.numberOfLines = 0
        titleLabel.lineSpacing(lineHeight: 36)
        
        nextButton.isEnabled = false
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([questionIcon, titleLabel, firstView, secondView, nextButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        questionIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.leading.equalToSuperview().inset(24)
            $0.width.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(questionIcon.snp.bottom).offset(8)
            $0.leading.equalTo(questionIcon)
        }
        
        firstView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(secondView.snp.top).offset(-12)
            $0.height.equalTo(180)
        }
        
        secondView.snp.makeConstraints {
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
