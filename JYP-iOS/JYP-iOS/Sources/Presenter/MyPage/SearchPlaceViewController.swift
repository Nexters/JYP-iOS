//
//  SearchPlaceViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/26.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import UIKit

class SearchPlaceViewController: BaseViewController {
    let navigationContentView = SearchPlaceNavigationContentView()
    let contentView = SearchPlaceView()
    
    lazy var navigationBar = NavigationBar(contentView: navigationContentView)
    
    override func setupProperty() {
        super.setupProperty()
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([navigationBar, contentView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
