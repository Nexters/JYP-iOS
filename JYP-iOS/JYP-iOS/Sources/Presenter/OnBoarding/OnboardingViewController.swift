//
//  OnboardingViewController.swift
//  JYP-iOSTests
//
//  Created by 송영모 on 2022/07/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class OnboardingViewController: NavigationBarViewController {
    // MARK: - UI Components
    
    let testLabel = JYPButton(config: .init(inactive: .init(title: "다음으로", titleColor: JYPIOSAsset.textWhite.color, backgroundColor: JYPIOSAsset.mainPink.color), active: .init(title: nil, titleColor: JYPIOSAsset.textB40.color, backgroundColor: JYPIOSAsset.tagWhiteGrey100.color)))
    
    // MARK: - Setup Methods
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        setNavigationBarTitleText("네비게이션 바 테스트")
        statusBar.backgroundColor = .green
        navigaionBar.backgroundColor = .blue
        contentView.backgroundColor = .magenta
    }
    
    override func setupProperty() {
        super.setupProperty()
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([testLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        testLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
}
