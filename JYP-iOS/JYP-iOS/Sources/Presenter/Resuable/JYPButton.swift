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
    case addPlace
    case smallAdd
    case smallMake
    case yes
    case no
    case invite
    case kakaoInvite
    case linkInvite
    case plannerJoin
    case confirm
    case nextTime
    
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
        case .addPlace:
            return "후보 장소 추가하기"
        case .smallAdd:
            return "시작하기"
        case .smallMake:
            return "만들기"
        case .yes:
            return "좋아요"
        case .no:
            return "싫어요"
        case .invite:
            return ""
        case .plannerJoin:
            return "입장하기"
        case .kakaoInvite:
            return "카카오톡 초대"
        case .linkInvite:
            return "참여코드 복사하기"
        case .confirm:
            return "확인했어요"
        case .nextTime:
            return "다음에 함께하기"
        }
    }
    
    var inactiveConfig: JYPButtonConfig {
        switch self {
        case .next:
            return .init(titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color, image: nil)
        case .done:
            return .init(titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color, image: nil)
        case .start:
            return .init(titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color, image: nil)
        case .startPlan:
            return .init(titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color, image: nil)
        case .add:
            return .init(titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color, image: nil)
        case .addPlace:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.subBlack.color, image: nil)
        case .smallAdd:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.subBlack.color, image: nil)
        case .smallMake:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color, image: nil)
        case .yes:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color, image: nil)
        case .no:
            return .init(titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color, image: nil)
        case .invite:
            return .init(titleColor: .clear, backgroundColor: .clear, image: JYPIOSAsset.iconInvite.image)
        case .kakaoInvite:
            return .init(titleColor: JYPIOSAsset.textB80.color, backgroundColor: UIColor(hex: 0xFAE000), image: nil)
        case .linkInvite, .confirm, .nextTime:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color, image: nil)
        case .plannerJoin:
            return .init(titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color, image: nil)
        }
    }
    
    var activeConfig: JYPButtonConfig? {
        switch self {
        case .next:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color, image: nil)
        case .done:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color, image: nil)
        case .start:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color, image: nil)
        case .startPlan:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color, image: nil)
        case .add:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color, image: nil)
        case .addPlace:
            return nil
        case .smallAdd:
            return nil
        case .smallMake:
            return nil
        case .yes:
            return nil
        case .no:
            return nil
        case .invite:
            return nil
        case .kakaoInvite:
            return nil
        case .linkInvite:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color, image: nil)
        case .plannerJoin:
            return .init(titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color, image: nil)
        case .confirm, .nextTime:
            return nil
        }
    }
}

struct JYPButtonConfig {
    let titleColor: UIColor
    let backgroundColor: UIColor
    let image: UIImage?
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
        setImage(type.inactiveConfig.image, for: .normal)
        backgroundColor = type.inactiveConfig.backgroundColor
        titleLabel?.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        cornerRound(radius: 12)
    }
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? type.activeConfig?.backgroundColor : type.inactiveConfig.backgroundColor
            if isEnabled {
                setTitleColor(type.activeConfig?.titleColor, for: .normal)
            } else {
                setTitleColor(type.inactiveConfig.titleColor, for: .normal)
            }
        }
    }
}
