//
//  PlannerHomeDiscussionJYPTagSectionHeader.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/12.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class PlannerHomeDiscussionJYPTagSectionHeader: BaseCollectionReusableView {
    let titleLabel = UILabel()
    let subLabel = UILabel()
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.text = "여행 태그"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.text = "여행 취향을 확인해보세요!"
        subLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
        subLabel.textColor = JYPIOSAsset.textB40.color
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([titleLabel, subLabel])
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
    }
}
