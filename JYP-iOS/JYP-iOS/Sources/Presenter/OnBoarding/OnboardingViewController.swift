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
    
    let testLabel = UILabel()
    
    
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
        
        testLabel.text = "dd"
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([testLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        testLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
    }
    
}
