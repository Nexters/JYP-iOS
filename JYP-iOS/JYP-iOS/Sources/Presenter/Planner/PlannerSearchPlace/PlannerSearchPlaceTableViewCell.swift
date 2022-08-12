//
//  DiscussionSearchPlaceTableViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/06.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class PlannerSearchPlaceTableViewCell: BaseTableViewCell {
    let titleLabel = UILabel()
    let subLabel = UILabel()
    let categoryImageView = UIImageView()
    let categoryLabel = UILabel()
    
    func update(title: String, sub: String, category: String) {
        titleLabel.text = title
        subLabel.text = sub
        categoryLabel.text = category
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        subLabel.text = ""
        categoryLabel.text = ""
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 17)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        subLabel.textColor = JYPIOSAsset.textB40.color
        
        categoryImageView.image = JYPIOSAsset.iconCulturePlace.image
        
        categoryLabel.text = "카테고리"
        categoryLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        categoryLabel.textColor = JYPIOSAsset.textB75.color
        categoryLabel.textAlignment = .right
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([titleLabel, subLabel, categoryImageView, categoryLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(8)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(1)
            $0.leading.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(14)
        }
        
        categoryImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(6)
            $0.width.height.equalTo(30)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(categoryImageView.snp.bottom).offset(1)
            $0.centerX.equalTo(categoryImageView)
        }
    }
}
