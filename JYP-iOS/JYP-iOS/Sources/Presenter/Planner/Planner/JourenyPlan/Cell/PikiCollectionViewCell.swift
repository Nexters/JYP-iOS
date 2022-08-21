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
    
    let circleView: UIView = .init()
    let circleLabel: UILabel = .init()
    let pikiView: UIView = .init()
    let titleLabel: UILabel = .init()
    let subLabel: UILabel = .init()
    let categoryImageView: UIImageView = .init()
    let categoryLabel: UILabel = .init()
    
    override func setupProperty() {
        super.setupProperty()
        
        backgroundColor = .clear
        
        pikiView.backgroundColor = JYPIOSAsset.backgroundWhite100.color
        pikiView.cornerRound(radius: 12)
        pikiView.setShadow(radius: 10, offset: CGSize(width: 4, height: 5), opacity: 0.06)
        
        circleView.backgroundColor = JYPIOSAsset.subBlack.color
        circleView.cornerRound(radius: 9.5)
            
        circleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 12)
        circleLabel.textColor = JYPIOSAsset.textWhite.color
        circleLabel.text = "1"
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 17)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        subLabel.textColor = JYPIOSAsset.tagGrey200.color
        
        categoryLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        categoryLabel.textColor = JYPIOSAsset.tagGrey200.color
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([circleView, circleLabel, pikiView])
        
        pikiView.addSubviews([titleLabel, subLabel, categoryImageView, categoryLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        circleView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(19)
        }
        
        circleLabel.snp.makeConstraints {
            $0.center.equalTo(circleView)
        }
        
        pikiView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(circleView.snp.trailing).offset(8)
        }
        
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
