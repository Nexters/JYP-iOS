//
//  PikmiRouteCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class PikmiRouteCollectionViewCell: BaseCollectionViewCell, View {
    typealias Reactor = PikmiRouteCollectionViewCellReactor
    
    // MARK: - UI Components
    
    let titleLabel: UILabel = .init()
    let subLabel: UILabel = .init()
    let rankBadgeImageView: UIImageView = .init()
    let categoryLabel: UILabel = .init()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        rankBadgeImageView.image = nil
    }
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        contentView.cornerRound(radius: 10)
        contentView.backgroundColor = .white
        contentView.setShadow(radius: 40, offset: .init(width: 4, height: 10), opacity: 0.06)
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 17)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        subLabel.textColor = JYPIOSAsset.tagGrey200.color
        
        categoryLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        categoryLabel.textColor = JYPIOSAsset.textB40.color
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([titleLabel, subLabel, rankBadgeImageView, categoryLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(20)
        }
        
        subLabel.snp.makeConstraints {
            $0.centerY.equalTo(categoryLabel)
            $0.leading.equalToSuperview().inset(20)
        }
        
        rankBadgeImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(23)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.centerX.equalTo(rankBadgeImageView)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    func bind(reactor: Reactor) {
        titleLabel.text = reactor.currentState.pik.name
        subLabel.text = reactor.currentState.pik.address
        categoryLabel.text = reactor.currentState.pik.category.title
        
        switch reactor.currentState.rank {
        case 0: rankBadgeImageView.image = JYPIOSAsset.badge1.image
        case 1: rankBadgeImageView.image = JYPIOSAsset.badge2.image
        case 2: rankBadgeImageView.image = JYPIOSAsset.badge3.image
        default: break
        }
    }
}
