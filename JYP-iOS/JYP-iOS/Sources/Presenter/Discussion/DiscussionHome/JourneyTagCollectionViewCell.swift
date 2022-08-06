//
//  JourneyTagCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/04.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class JourneyTagSectionHeader: BaseCollectionReusableView {
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

class JourneyTagCollectionViewCell: BaseCollectionViewCell {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    func update(title: String) {
        imageView.image = JYPIOSAsset.iconLikeUnselect.image
        titleLabel.text = title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        titleLabel.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.cornerRound(radius: 15, direct: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        contentView.backgroundColor = JYPIOSAsset.tagWhiteBlue100.color

        titleLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        titleLabel.textColor = JYPIOSAsset.subBlue300.color
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([imageView, titleLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        imageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(4)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(9)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
