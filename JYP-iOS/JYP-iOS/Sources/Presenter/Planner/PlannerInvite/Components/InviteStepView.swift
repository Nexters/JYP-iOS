//
//  InviteStepView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/02/19.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import UIKit

class InviteStepView: BaseView {
    // MARK: - Sub Type
    
    enum InviteStepViewType: CaseIterable {
        case one
        case two
        case three
        
        var stepTitle: String {
            switch self {
            case .one: return "STEP 1"
            case .two: return "STEP 2"
            case .three: return "STEP 3"
            }
        }
        
        var title: String {
            switch self {
            case .one: return "참여코드를 일행에게 전달해주세요."
            case .two: return "참여코드를 받은 일행은\n저니피키 서비스를 설치해주세요."
            case .three: return "‘나의 여행’ 화면에서 ‘+’를 선택하고\n‘참여코드로 플래너 입장하기’를\n해주세요"
            }
        }
        
        var image: UIImage {
            switch self {
            case .one: return JYPIOSAsset.stepOne.image
            case .two: return JYPIOSAsset.stepTwo.image
            case .three: return JYPIOSAsset.stepThree.image
            }
        }
    }
    
    // MARK: - Properties
    
    let type: InviteStepViewType
    
    // MARK: - UI Components
    
    let stepView: UIView = .init()
    let stepLabel: UILabel = .init()
    let titleLabel: UILabel = .init()
    let imageView: UIImageView = .init()
    
    // MARK: - Initializer
    
    init(type: InviteStepViewType) {
        self.type = type
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        stepView.backgroundColor = .init(hex: 0xFFEFF4)
        stepView.cornerRound(radius: 8)
        
        stepLabel.textColor = JYPIOSAsset.tagRed300.color
        stepLabel.font = JYPIOSFontFamily.Pretendard.bold.font(size: 15)
        stepLabel.text = type.stepTitle
        
        titleLabel.text = type.title
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        titleLabel.numberOfLines = 0
        
        imageView.image = type.image
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([stepView, titleLabel, imageView])
        stepView.addSubviews([stepLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        stepView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        stepLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2.5)
            $0.leading.trailing.equalToSuperview().inset(11)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(stepView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.trailing.bottom.equalToSuperview()
            $0.width.equalTo(287)
        }
    }
}
