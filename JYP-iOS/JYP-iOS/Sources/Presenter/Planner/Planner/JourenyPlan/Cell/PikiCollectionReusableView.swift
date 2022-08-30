//
//  PikiCollectionReusableView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class PikiCollectionReusableView: BaseCollectionReusableView {
    
    // MARK: - UI Components
    
    let titleLabel: UILabel = .init()
    let subLabel: UILabel = .init()
    let trailingButton: UIButton = .init()
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        titleLabel.text = "Day 1"
        
        subLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        subLabel.textColor = JYPIOSAsset.textB40.color
        subLabel.text = "7월 18일"
        
        trailingButton.setImage(JYPIOSAsset.iconModify.image, for: .normal)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([titleLabel, subLabel, trailingButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(4)
            $0.centerY.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(14)
            $0.centerY.equalToSuperview()
        }
        
        trailingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(4)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
}
