//
//  PikmiRouteCollectionReusableView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/31.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class PikmiRouteCollectionReusableView: BaseCollectionReusableView { 
    // MARK: - UI Components
    
    let titleLabel: UILabel = .init()
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.text = "여행 후보 장소"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        titleLabel.textColor = JYPIOSAsset.textB80.color
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([titleLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
