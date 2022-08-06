//
//  JourneyPlaceCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/04.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class JourneyPlaceSectionHeader: BaseCollectionReusableView {
    let titleLabel = UILabel()
    let subLabel = UILabel()
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.text = "여행 후보 장소"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.text = "투표를 통해 여행 장소를 선정하세요!"
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

class JourneyPlaceEmptyCollectionViewCell: BaseCollectionViewCell {
    let circleImageView = UIImageView()
    let addButton = JYPButton(type: .add)
    
    func update() {
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        contentView.setShadow(radius: 40, offset: CGSize(width: 4, height: 10), opacity: 0.06)
        
        circleImageView.cornerRound(radius: 52.5)
        circleImageView.backgroundColor = .systemGray6
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([circleImageView, addButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        circleImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(27)
            $0.centerX.equalToSuperview()
        }
        
        addButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
    }
}

class JourneyPlaceCollectionViewCell: BaseCollectionViewCell {
    let categoryLabel = UILabel()
    let titleLabel = UILabel()
    let subLabel = UILabel()
    let rankBadgeImageView = UIImageView()
    let infoButton = UIButton()
    let likeButton = UIButton()
    
    func update() {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.setShadow(radius: 20, offset: CGSize(width: 4, height: 10), opacity: 0.05)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        contentView.backgroundColor = JYPIOSAsset.backgroundWhite100.color
        contentView.cornerRound(radius: 12)
        
        categoryLabel.text = "박물관"
        categoryLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        categoryLabel.textColor = JYPIOSAsset.tagGrey200.color
        
        titleLabel.text = "아르떼 뮤지엄"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 20)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.text = "강원 강릉시 난설헌로 131"
        subLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        subLabel.textColor = JYPIOSAsset.tagGrey200.color
        
        rankBadgeImageView.image = JYPIOSAsset.badge1.image
        
        infoButton.setTitle("정보 보기", for: .normal)
        infoButton.setTitleColor(JYPIOSAsset.textB80.color, for: .normal)
        infoButton.setImage(JYPIOSAsset.infoPlace.image, for: .normal)
        infoButton.titleLabel?.textColor = JYPIOSAsset.textB80.color
        infoButton.titleLabel?.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        infoButton.cornerRound(radius: 8)
        infoButton.backgroundColor = JYPIOSAsset.backgroundWhite100.color
        infoButton.setShadow(radius: 12, offset: .init(width: 2, height: 2), opacity: 0.1)
        
        likeButton.cornerRound(radius: 31)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([categoryLabel, titleLabel, subLabel, rankBadgeImageView, infoButton, likeButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        categoryLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(7)
            $0.leading.equalToSuperview().inset(20)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(20)
        }
        
        infoButton.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(20)
            $0.width.equalTo(114)
            $0.height.equalTo(40)
        }
        
        rankBadgeImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(38)
        }
        
        likeButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(20)
            $0.width.height.equalTo(62)
        }
    }
}
