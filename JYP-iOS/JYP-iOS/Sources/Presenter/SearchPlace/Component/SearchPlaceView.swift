//
//  SearchPlaceView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/26.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class SearchPlaceNavigationContentView: BaseView {
    let searchTextField = UITextField()
    let searchButton = UIButton(type: .system)
    
    override func setupProperty() {
        super.setupProperty()
        
        searchTextField.backgroundColor = .clear
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.borderColor = UIColor.systemGray4.cgColor
        searchTextField.layer.borderWidth = 1
        searchTextField.placeholder = " 예) 서울 저니식당"
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: searchTextField.frame.height))
        searchTextField.leftViewMode = .always
        
        searchButton.backgroundColor = .black
        searchButton.layer.cornerRadius = 10
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([searchTextField, searchButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        searchTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(5)
        }
        
        searchButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalTo(searchTextField.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(49)
        }
    }
}

class SearchPlaceView: BaseView {
    let searchResultTableView = UITableView()
    let guideLabel = UILabel()
    
    override func setupProperty() {
        super.setupProperty()
        
        searchResultTableView.register(SearchPlaceResultTableViewCell.self, forCellReuseIdentifier: String(describing: SearchPlaceResultTableViewCell.self))
        
//        guideLabel.text = "일행과 공유할 장소를\n검색해주세요!"
        guideLabel.numberOfLines = 0
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([searchResultTableView, guideLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        searchResultTableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        guideLabel.snp.makeConstraints {
            $0.center.equalTo(searchResultTableView)
        }
    }
}
