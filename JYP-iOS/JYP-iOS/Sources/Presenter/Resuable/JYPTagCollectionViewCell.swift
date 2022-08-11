//
//  JYPTagCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class JYPTagCollectionViewCell: BaseCollectionViewCell {
    var jypTag: JYPTag?
    
    func update(type: JYPTagType) {
        jypTag = JYPTag(type: type, title: "안녕")
        
        // FIXME: 테스트 용
        if Bool.random() {
            jypTag?.isSelected = false
        } else {
            jypTag?.isSelected = true
        }
        
        if Bool.random() {
            jypTag?.isInactive = false
        } else {
            jypTag?.isInactive = true
        }
        
        setupHierarchy()
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        jypTag?.removeFromSuperview()
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        guard let jypTag = jypTag else { return }

        contentView.addSubview(jypTag)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        guard let jypTag = jypTag else { return }
        
        jypTag.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
