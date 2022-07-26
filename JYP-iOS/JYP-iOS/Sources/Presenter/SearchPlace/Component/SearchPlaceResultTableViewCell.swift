//
//  SearchPlaceResultTableViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/26.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import UIKit

class SearchPlaceResultTableViewCell: BaseTableViewCell {
    static let id = "SearchPlaceResultTableViewCell"
    let titleLabel = UILabel()
    let subLabel = UILabel()
    let categoryLabel = UILabel()
    
    func update(title: String, sub: String, category: String) {
        titleLabel.text = title
        subLabel.text = sub
        categoryLabel.text = category
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        subLabel.text = ""
        categoryLabel.text = ""
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.text = "아르떼 뮤지엄"
        titleLabel.font = .systemFont(ofSize: 16)
        
        subLabel.text = "강원도 강릉시 난설헌로 131"
        subLabel.font = .systemFont(ofSize: 12)
        
        categoryLabel.text = "카테고리"
        categoryLabel.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([titleLabel, subLabel, categoryLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(34)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(22)
            $0.centerY.equalToSuperview()
        }
    }
}
