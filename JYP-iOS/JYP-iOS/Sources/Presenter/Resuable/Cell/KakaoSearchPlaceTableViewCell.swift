//
//  DiscussionSearchPlaceTableViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/06.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class KakaoSearchPlaceTableViewCell: BaseTableViewCell, View {
    typealias Reactor = KakaoSearchPlaceTableViewCellReactor
    
    let titleLabel = UILabel()
    let subLabel = UILabel()
    let categoryImageView = UIImageView()
    let categoryLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        subLabel.text = ""
        categoryLabel.text = ""
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 17)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        subLabel.textColor = JYPIOSAsset.textB40.color
        
        categoryLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        categoryLabel.textColor = JYPIOSAsset.textB75.color
        categoryLabel.textAlignment = .right
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([titleLabel, subLabel, categoryImageView, categoryLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalTo(categoryImageView.snp.leading).offset(8)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(1)
            $0.leading.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(14)
        }
        
        categoryImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(6)
            $0.width.height.equalTo(30)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(categoryImageView.snp.bottom).offset(1)
            $0.centerX.equalTo(categoryImageView)
        }
    }
    
    func bind(reactor: Reactor) {
        let state = reactor.currentState
        
        titleLabel.text = state.placeName
        
        subLabel.text = state.addressName
        
        categoryLabel.text = JYPCategoryType.getJYPCategoryType(categoryGroupCode: state.categoryGroupCode).title
        
        categoryImageView.image = JYPCategoryType.getJYPCategoryType(categoryGroupCode: state.categoryGroupCode).image
    }
}
