//
//  OnboardingQuestionView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

enum OnboardingQuestionViewType {
    case whatIsJourney
    case howToNewPlace
    case whenJourneyPlan
    
    var titleText: String {
        switch self {
        case .whatIsJourney:
            return "본인이 생각하는 여행이란\n무엇인가요?"
        case .howToNewPlace:
            return "여행 중, 새로운 장소를 발견하면\n어떤 선택을 하실 건가요?"
        case .whenJourneyPlan:
            return "여행 계획을 세울 때,\n어떤 모습이신가요?"
        }
    }
    
    var cardViewTypeA: OnboardingCardViewType {
        switch self {
        case .whatIsJourney:
            return .whatIsJourneyA
        case .howToNewPlace:
            return .howToNewPlaceA
        case .whenJourneyPlan:
            return .whenJourneyPlanA
        }
    }
    
    var cardViewTypeB: OnboardingCardViewType {
        switch self {
        case .whatIsJourney:
            return .whatIsJourneyB
        case .howToNewPlace:
            return .howToNewPlaceB
        case .whenJourneyPlan:
            return .whenJourneyPlanB
        }
    }
}

class OnboardingQuestionView: BaseView {
    let type: OnboardingQuestionViewType
    
    var questionIcon: UIImageView!
    var titleLabel: UILabel!
    var onboardingCardViewA: OnboardingCardView!
    var onboardingCardViewB: OnboardingCardView!
    var nextButton: JYPButton!
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(type: OnboardingQuestionViewType) {
        self.type = type
        super.init(frame: .zero)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        questionIcon = .init().then {
            $0.image = JYPIOSAsset.iconQuestion.image
        }
        
        titleLabel = .init().then {
            $0.textColor = JYPIOSAsset.textB90.color
            $0.text = type.titleText
            $0.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 24)
            $0.numberOfLines = 2
        }
        
        nextButton = .init(type: .next).then {
            $0.isEnabled = false
        }
        
        onboardingCardViewA = .init(type: type.cardViewTypeA)
        
        onboardingCardViewB = .init(type: type.cardViewTypeB)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([questionIcon, titleLabel, onboardingCardViewA, onboardingCardViewB, nextButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        questionIcon.snp.makeConstraints {
            $0.top.equalToSuperview().inset(64)
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
