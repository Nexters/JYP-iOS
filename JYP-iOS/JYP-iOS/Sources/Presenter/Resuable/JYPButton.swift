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
    
    var inactiveConfig: JYPButtonConfig {
        switch self {
        case .next:
            return .init(title: "다음으로", titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color)
        case .done:
            return .init(title: "완료하기", titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color)
        case .start:
            return .init(title: "시작하기", titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color)
        case .startPlan:
            return .init(title: "여행 계획 시작하기", titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color)
        case .add:
            return .init(title: "추가하기", titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color)
        case .smallAdd:
            return .init(title: "시작하기", titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.subBlack.color)
        case .smallMake:
            return .init(title: "만들기", titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color)
        case .yes:
            return .init(title: "좋아요", titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color)
        case .no:
            return .init(title: "싫어요", titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color)
        }
    }
    
    var activeConfig: JYPButtonConfig? {
        switch self {
        case .next:
            return .init(title: "다음으로", titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color)
        case .done:
            return .init(title: "완료하기", titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color)
        case .start:
            return .init(title: "시작하기", titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color)
        case .startPlan:
            return .init(title: "여행 계획 시작하기", titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color)
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
    let title: String
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
         
        setTitle(type.inactiveConfig.title, for: .normal)
        setTitleColor(type.inactiveConfig.titleColor, for: .normal)
        backgroundColor = type.inactiveConfig.backgroundColor
        layer.cornerRadius = 12
        titleLabel?.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        if let activeConfig = type.activeConfig {
            setTitle(activeConfig.title, for: .selected)
            setTitleColor(activeConfig.titleColor, for: .selected)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? type.activeConfig?.backgroundColor : type.inactiveConfig.backgroundColor
            titleLabel?.textColor = isSelected ? type.activeConfig?.titleColor : type.inactiveConfig.titleColor
        }
    }
}
