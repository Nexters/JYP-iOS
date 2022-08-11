//
//  DiscusstionInviteViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/06.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

class DiscusstionInviteViewController: NavigationBarViewController {
    let selfView = DiscussionInviteView()
    
    override func setupNavigationBar() {
        super.setupNavigationBar() 
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubview(selfView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        selfView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
