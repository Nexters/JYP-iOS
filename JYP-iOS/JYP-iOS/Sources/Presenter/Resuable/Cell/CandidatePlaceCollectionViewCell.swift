//
//  CandidatePlaceCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class CandidatePlaceCollectionViewCell: BaseCollectionViewCell, View {
    typealias Reactor = CandidatePlaceCollectionViewCellReactor
    
    let categoryLabel = UILabel()
    let titleLabel = UILabel()
    let subLabel = UILabel()
    let rankBadgeImageView = UIImageView()
    let infoButton = UIButton()
    let likeButton = UIButton()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.setShadow(radius: 20, offset: CGSize(width: 4, height: 10), opacity: 0.05)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        contentView.backgroundColor = JYPIOSAsset.backgroundWhite100.color
        contentView.cornerRound(radius: 12)
        
        categoryLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        categoryLabel.textColor = JYPIOSAsset.tagGrey200.color
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 20)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
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
    
    func bind(reactor: Reactor) {
        let state = reactor.currentState
        
        categoryLabel.text = state.candidatePlace.category.title
        
        titleLabel.text = state.candidatePlace.name
        
        switch state.rank {
        case 0:
            rankBadgeImageView.image = JYPIOSAsset.badge1.image
        case 1:
            rankBadgeImageView.image = JYPIOSAsset.badge2.image
        case 2:
            rankBadgeImageView.image = JYPIOSAsset.badge3.image
        default: break
        }
    }
}
