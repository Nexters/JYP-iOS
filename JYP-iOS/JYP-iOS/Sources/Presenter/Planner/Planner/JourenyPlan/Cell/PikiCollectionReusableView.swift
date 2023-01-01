//
//  PikiCollectionReusableView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class PikiCollectionReusableView: BaseCollectionReusableView, View {
    typealias Reactor = PikiCollectionReusableViewReactor
    
    // MARK: - UI Components
    
    let titleLabel: UILabel = .init()
    let subLabel: UILabel = .init()
    let trailingButton: UIButton = .init()
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        subLabel.textColor = JYPIOSAsset.textB40.color
        
        trailingButton.setImage(JYPIOSAsset.iconModify.image, for: .normal)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([titleLabel, subLabel, trailingButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(4)
            $0.centerY.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(14)
            $0.centerY.equalToSuperview()
        }
        
        trailingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(4)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
    
    func bind(reactor: Reactor) {
        titleLabel.text = "Day \(reactor.currentState.order + 1)"
        
        if let journey = reactor.currentState.journey {
            var date = Date(timeIntervalSince1970: journey.startDate)
            date = DateManager.addDateComponent(byAdding: .day, value: reactor.currentState.order, to: date)
            subLabel.text = DateManager.dateToString(format: "M월 d일", date: date)
        }
    }
}
