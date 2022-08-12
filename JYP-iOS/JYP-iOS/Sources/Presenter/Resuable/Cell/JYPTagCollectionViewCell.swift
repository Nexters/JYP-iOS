//
//  JYPTagCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class JYPTagCollectionViewCell: BaseCollectionViewCell, View {
    typealias Reactor = JYPTagCollectionViewCellReactor
    
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
        jypTag.type = reactor.currentState.type
        jypTag.titleLabel.text = reactor.currentState.text
    }
}
