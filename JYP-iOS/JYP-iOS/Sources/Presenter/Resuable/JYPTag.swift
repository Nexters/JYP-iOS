//
//  JYPTag.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/10.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

struct JYPTagConfig {
    let image: UIImage?
    let textColor: UIColor
    let backgroundColor: UIColor
}

enum JYPTagType {
    case soso
    case like
    case dislike
    
    var inactiveConfig: JYPTagConfig {
        switch self {
        case .soso:
            return JYPTagConfig(image: JYPIOSAsset.iconDontCareUnselect.image.grayscale(), textColor: JYPIOSAsset.tagGrey200.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color)
        case .like:
            return JYPTagConfig(image: JYPIOSAsset.iconLikeUnselect.image.grayscale(), textColor: JYPIOSAsset.tagGrey200.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color)
        case .dislike:
            return JYPTagConfig(image: JYPIOSAsset.iconHateUnselect.image.grayscale(), textColor: JYPIOSAsset.tagGrey200.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color)
        }
    }
    
    var unselectedConfig: JYPTagConfig {
        switch self {
        case .soso:
            return JYPTagConfig(image: JYPIOSAsset.iconDontCareUnselect.image, textColor: JYPIOSAsset.tagOrange300.color, backgroundColor: JYPIOSAsset.tagWhiteOrange100.color)
        case .like:
            return JYPTagConfig(image: JYPIOSAsset.iconLikeUnselect.image, textColor: JYPIOSAsset.subBlue300.color, backgroundColor: JYPIOSAsset.tagWhiteBlue100.color)
        case .dislike:
            return JYPTagConfig(image: JYPIOSAsset.iconHateUnselect.image, textColor: JYPIOSAsset.tagRed300.color, backgroundColor: JYPIOSAsset.tagWhiteRed100.color)
        }
    }
    
    var selectedConfig: JYPTagConfig {
        switch self {
        case .soso:
            return JYPTagConfig(image: JYPIOSAsset.iconDontCareSelect.image, textColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.tagOrange200.color)
        case .like:
            return JYPTagConfig(image: JYPIOSAsset.iconLikeSelect.image, textColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.tagBlue100.color)
        case .dislike:
            return JYPTagConfig(image: JYPIOSAsset.iconHateSelect.image, textColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.tagRed200.color)
        }
    }
}

class JYPTag: BaseView {
    var type: JYPTagType? {
        didSet {
            if type != nil {
                isSelected = false
                isInactive = false
            } else {
                return
            }
        }
    }
    
    var isSelected: Bool {
        didSet {
            if isSelected {
                imageView.image = type?.selectedConfig.image
                titleLabel.textColor = type?.selectedConfig.textColor
                backgroundColor = type?.selectedConfig.backgroundColor
            } else {
                imageView.image = type?.unselectedConfig.image
                titleLabel.textColor = type?.unselectedConfig.textColor
                backgroundColor = type?.unselectedConfig.backgroundColor
            }
        }
    }
    
    var isInactive: Bool {
        didSet {
            if isInactive {
                imageView.image = type?.inactiveConfig.image
                titleLabel.textColor = type?.inactiveConfig.textColor
                backgroundColor = type?.inactiveConfig.backgroundColor
            } else {
                isSelected = Bool(isSelected)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init() {
        isSelected = false
        isInactive = false
        super.init(frame: .zero)
    }
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    override func setupProperty() {
        super.setupProperty()
        
        cornerRound(radius: 15)
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([imageView, titleLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        imageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(4)
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(9)
            $0.trailing.equalToSuperview().inset(6)
            $0.centerY.equalToSuperview()
        }
    }
}
