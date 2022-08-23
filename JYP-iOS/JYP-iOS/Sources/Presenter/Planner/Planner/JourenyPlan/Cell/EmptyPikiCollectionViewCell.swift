//
//  EmptyPikiCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/23.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class EmptyPikiCollectionViewCellReactor: Reactor {
    enum Action { }
    enum Mutation { }
    
    struct State {
        let order: Int
        let date: Double
    }

    var initialState: State
    
    init(state: State) {
        initialState = state
    }
}

class EmptyPikiCollectionViewCell: BaseCollectionViewCell, View {
    typealias Reactor = EmptyPikiCollectionViewCellReactor
    
    // MARK: - UI Components
    
    let titleLabel: UILabel = .init()
    let subLabel: UILabel = .init()
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        makeBorder(color: .black.withAlphaComponent(0.1), width: 1)

        cornerRound(radius: 12)
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        subLabel.textColor = JYPIOSAsset.textB40.color
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([titleLabel, subLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        titleLabel.text = "Day \(reactor.currentState.order + 1)"
        subLabel.text = "Day \(reactor.currentState.date)"
    }
}
