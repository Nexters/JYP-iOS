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
        reactor.state
            .map(\.orientation)
            .bind(to: jypTag.rx.type)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.topic)
            .bind(to: jypTag.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isSelected)
            .bind(to: jypTag.rx.isSelected)
            .disposed(by: disposeBag)
    }
}
