//
//  DiscussionTagBottomSheetViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class DiscussionTagBottomSheetViewController: BottomSheetViewController {
    let bottomSheetView = UIView()
    let titleLabel = UILabel()
    let tag = JYPTag(type: .like("바다"))
    let imageStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addContentView(view: bottomSheetView)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        for _ in 0...3 {
            let imageBox = ImageBox(image: JYPIOSAsset.iconCulturePlace.image, title: "이소")
            
            imageStackView.addArrangedSubview(imageBox)
        }
        
        titleLabel.text = "좋아요 태그"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 20)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        tag.isSelected = false
        
        imageStackView.distribution = .equalSpacing
        imageStackView.spacing = 12
        imageStackView.alignment = .leading
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        bottomSheetView.addSubviews([titleLabel, tag, imageStackView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.leading.equalToSuperview()
        }
        
        tag.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview()
        }
        
        imageStackView.snp.makeConstraints {
            $0.top.equalTo(tag.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(23)
        }
    }
    
    override func setupBind() {
        super.setupBind()
    }
}
