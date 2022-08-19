//
//  JourneyPlaceCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class PikiCollectionViewCell: BaseCollectionViewCell, View {
    typealias Reactor = PikiCollectionViewCellReactor
    
    let titleLabel = UILabel()
    let subLabel = UILabel()
    let categoryImageView = UIImageView()
    let categoryLabel = UILabel()
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 17)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        subLabel.textColor = JYPIOSAsset.tagGrey200.color
        
        categoryLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        categoryLabel.textColor = JYPIOSAsset.tagGrey200.color
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([titleLabel, subLabel, categoryImageView, categoryLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
        }
        
        categoryImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(19)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(categoryImageView.snp.bottom).offset(4)
            $0.centerX.equalTo(categoryImageView)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    func bind(reactor: Reactor) {
        titleLabel.text = reactor.currentState.name
        subLabel.text = reactor.currentState.address
        categoryImageView.image = reactor.currentState.category.image
        categoryLabel.text = reactor.currentState.category.title
    }
}
