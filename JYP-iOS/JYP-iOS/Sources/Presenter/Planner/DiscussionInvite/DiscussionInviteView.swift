//
//  DiscussionInviteView.swift
//  JYP-iOSTests
//
//  Created by 송영모 on 2022/08/06.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class DiscussionInviteView: BaseView {
    let titleLabel = UILabel()
    let subLabel = UILabel()
    let buttonStackView = UIStackView()
    let kakaoInviteButton = JYPButton(type: .kakaoInvite)
    let linkInviteButton = JYPButton(type: .linkInvite)
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.text = "일행을 초대해 주세요!"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 24)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.text = "일행과 함께 여행기를 만들어요"
        subLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        subLabel.textColor = JYPIOSAsset.tagGrey200.color
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 13
        
        kakaoInviteButton.isEnabled = false
        linkInviteButton.isEnabled = false
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([titleLabel, subLabel, buttonStackView])
        
        buttonStackView.addArrangedSubview(kakaoInviteButton)
        buttonStackView.addArrangedSubview(linkInviteButton)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9)
            $0.leading.equalToSuperview().inset(24)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
    }
}
