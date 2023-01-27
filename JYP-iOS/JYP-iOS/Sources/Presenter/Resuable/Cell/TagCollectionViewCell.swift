//
//  TagCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class TagCollectionViewCell: BaseCollectionViewCell, View {
    typealias Reactor = TagCollectionViewCellReactor
    
    var jypTag = JYPTag()
      
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubview(jypTag)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        jypTag.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        jypTag.type = reactor.currentState.orientation
        jypTag.titleLabel.text = reactor.currentState.text
    }
}
