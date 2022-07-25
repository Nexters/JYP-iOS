//
//  SearchPlaceView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/26.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import UIKit

class SearchPlaceNavigationContentView: BaseView {
    let searchTextField = UITextField()
    
    override func setupProperty() {
        super.setupProperty()
        
        searchTextField.backgroundColor = .blue
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([searchTextField])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(5)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

class SearchPlaceView: BaseView {
    let backButton = UIButton(type: .system)
    let searchTextField = UITextField()
    let searchResultTableView = UITableView()
    let guideLabel = UILabel()
    
    override func setupProperty() {
        super.setupProperty()
        
        backButton.setTitle("뒤로가기 버튼", for: .normal)
        
        guideLabel.text = "일행과 공유할 장소를\n검색해주세요!"
        guideLabel.numberOfLines = 0
        
        searchTextField.placeholder = "예) 서울 저니 식당"
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([backButton, searchTextField, searchResultTableView, guideLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
        }
    }
}
