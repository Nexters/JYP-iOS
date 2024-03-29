//
//  PlannerHomeDiscussionCandidatePlaceSectionHeader.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/12.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class DiscussionPikmiSectionHeader: BaseCollectionReusableView {
    let titleLabel = UILabel()
    let subLabel = UILabel()
    let trailingButton = UIButton()
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.text = "여행 후보 장소"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.text = "투표를 통해 여행 장소를 선정하세요!"
        subLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
        subLabel.textColor = JYPIOSAsset.textB40.color
        
        trailingButton.setImage(JYPIOSAsset.iconAdd.image, for: .normal)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([titleLabel, subLabel, trailingButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(24)
        }
        
        trailingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalTo(titleLabel)
            $0.width.height.equalTo(24)
        }
    }
}
