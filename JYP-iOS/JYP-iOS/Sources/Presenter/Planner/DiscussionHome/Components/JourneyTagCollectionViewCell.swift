//
//  JourneyTagCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/04.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class JourneyTagCollectionViewCell: BaseCollectionViewCell {
    var jypTag: JYPTag?
    
    func update(type: JYPTagType, title: String) {
        jypTag = JYPTag(type: type, title: title)
        
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
