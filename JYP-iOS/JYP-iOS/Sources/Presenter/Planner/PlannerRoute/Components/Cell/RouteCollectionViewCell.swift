//
//  RouteCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class RouteCollectionViewCell: BaseCollectionViewCell, View {
    typealias Reactor = RouteCollectionViewCellReactor
    
    // MARK: - UI Components
    
    let routeView: UIView = .init()
    let subLabel: UILabel = .init()
    let titleLabel: UILabel = .init()
    let deleteButton: UIButton = .init()
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        routeView.cornerRound(radius: 12)
        routeView.backgroundColor = .white
        routeView.setShadow(radius: 40, offset: .init(width: 4, height: 10), opacity: 0.06)
        
        subLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        subLabel.textColor = JYPIOSAsset.tagGrey200.color
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 18)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        deleteButton.setImage(JYPIOSAsset.iconPlaceDeletBtn.image, for: .normal)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        routeView.addSubviews([subLabel, titleLabel])
        
        contentView.addSubviews([routeView, deleteButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        routeView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7)
            $0.trailing.equalToSuperview().inset(6)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().inset(16)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
    
    // MARK: - Bind Method
    
    func bind(reactor: Reactor) {
        subLabel.text = reactor.currentState.pik?.category.title
        titleLabel.text = reactor.currentState.pik?.name
    }
}
