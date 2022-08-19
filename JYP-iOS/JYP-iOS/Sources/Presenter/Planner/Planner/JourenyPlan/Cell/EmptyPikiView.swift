//
//  EmptyPikiView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/20.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class EmptyPikiView: BaseView {
    // MARK: - UI Components
    
    let titleLabel: UILabel = .init()
    let subLabel: UILabel = .init()
    
    // MARK: - Initializer
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, sub: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        subLabel.text = sub
    }
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        makeBorder(color: JYPIOSAsset.tagWhiteGrey100.color, width: 1)
        cornerRound(radius: 12)
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        subLabel.textColor = JYPIOSAsset.textB40.color
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([titleLabel, subLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
    }
}
