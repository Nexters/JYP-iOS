//
//  MyPageViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/17.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class MyPageViewController: BaseViewController {
    let titleLabel = UILabel()
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.text = "마이 페이지 뷰컨"
        titleLabel.textColor = .black
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubview(titleLabel)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
