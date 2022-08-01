//
//  JYPButton.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

enum JYPButtonType {
    case next
    case done
    case start
    case startPlan
    case add
    case smallAdd
    case smallMake
    case yes
    case no
    
    var title: String {
        switch self {
        case .next:
            return "다음으로"
        case .done:
            return "완료하기"
        case .start:
            return "시작하기"
        case .startPlan:
            return "여행 계획 시작하기"
        case .add:
            return "추가하기"
        case .smallAdd:
            return "시작하기"
        case .smallMake:
            return "만들기"
        case .yes:
            return "좋아요"
        case .no:
            return "싫어요"
        }
    }
    
    var inactiveConfig: JYPButtonConfig {
        switch self {
        case .next:
            return .init(titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color)
        case .done:
            return .init(titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color)
        case .start:
            return .init(titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color)
        case .startPlan:
            return .init(titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color)
        case .add:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color)
        case .smallAdd:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.subBlack.color)
        case .smallMake:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color)
        case .yes:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color)
        case .no:
            return .init(titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color)
        }
    }
    
    var activeConfig: JYPButtonConfig? {
        switch self {
        case .next:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color)
        case .done:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color)
        case .start:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color)
        case .startPlan:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color)
        case .add:
            return nil
        case .smallAdd:
            return nil
        case .smallMake:
            return nil
        case .yes:
            return nil
        case .no:
            return nil
        }
    }
}

struct JYPButtonConfig {
    let titleColor: UIColor
    let backgroundColor: UIColor
}

class JYPButton: UIButton {
    let type: JYPButtonType
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(type: JYPButtonType) {
        self.type = type
        
        super.init(frame: .zero)
        
        setTitle(type.title, for: .normal)
        backgroundColor = type.inactiveConfig.backgroundColor
        titleLabel?.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? type.activeConfig?.backgroundColor : type.inactiveConfig.backgroundColor
            isEnabled ? setTitleColor(type.activeConfig?.titleColor, for: .normal) : setTitleColor(type.inactiveConfig.titleColor, for: .normal)
        }
    }
}
