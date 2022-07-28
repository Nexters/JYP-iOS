//
//  AddPlaceBox.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/26.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import UIKit

class AddPlaceBox: BaseView {
    let titleLabel = UILabel()
    let subLabel = UILabel()
    let categoryImageView = UIImageView()
    let categoryLabel = UILabel()
    let infoButton = UIButton()
    let addButton = UIButton()
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .black
        
        subLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subLabel.textColor = .darkGray
        
        categoryImageView.image = UIImage(systemName: "star")?.withTintColor(.black)
        categoryImageView.sizeToFit()
        
        categoryLabel.font = .systemFont(ofSize: 12, weight: .regular)
        categoryLabel.textColor = .darkGray
        
        infoButton.setImage(UIImage(systemName: "star")?.withTintColor(.black), for: .normal)
        infoButton.setTitle(" 정보 보기", for: .normal)
        infoButton.setTitleColor(.darkGray, for: .normal)
        infoButton.layer.borderColor = UIColor.darkGray.cgColor
        infoButton.layer.borderWidth = 1
        infoButton.layer.cornerRadius = 8
        infoButton.contentEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
        infoButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        infoButton.backgroundColor = .white
        
        addButton.setTitle("추가 하기", for: .normal)
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = .systemPink
        addButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([titleLabel, subLabel, categoryImageView, categoryLabel, infoButton, addButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25)
            $0.leading.equalToSuperview().inset(24)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(titleLabel)
        }
        
        categoryImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(39)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(categoryImageView.snp.bottom)
            $0.centerX.equalTo(categoryImageView)
        }
        
        infoButton.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(39)
        }
        
        addButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.leading.trailing.bottom.equalToSuperview().inset(12)
        }
    }
}
