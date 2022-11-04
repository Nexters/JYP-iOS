//
//  PlannerHomeDiscussionJYPTagSectionHeader.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/12.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class DiscussionTagSectionHeader: BaseCollectionReusableView {
    // MARK: - UI Components
    
    let titleLabel: UILabel = .init()
    let subLabel: UILabel = .init()
    let editButton: UIButton = .init()
    let toggleButton: UIButton = .init()
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.text = "여행 태그"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.text = "여행 취향을 확인해보세요!"
        subLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
        subLabel.textColor = JYPIOSAsset.textB40.color
        
        editButton.setImage(JYPIOSAsset.iconModify.image, for: .normal)
        
        toggleButton.setImage(JYPIOSAsset.iconOpen.image, for: .normal)
        toggleButton.setImage(JYPIOSAsset.iconClose.image, for: .selected)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([titleLabel, subLabel, editButton, toggleButton])
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
        
        editButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(60)
            $0.width.height.equalTo(24)
        }
        
        toggleButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
    }
}
