//
//  EmptyPikiCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/23.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class EmptyPlanCollectionViewCellReactor: Reactor {
    enum Action { }
    enum Mutation { }
    
    struct State {
        let order: Int
        let date: Date
    }

    var initialState: State
    
    init(state: State) {
        initialState = state
    }
}

class EmptyPikiCollectionViewCell: BaseCollectionViewCell, View {
    typealias Reactor = EmptyPlanCollectionViewCellReactor
    
    // MARK: - UI Components
    
    let titleLabel: UILabel = .init()
    let subLabel: UILabel = .init()
    let trailingButton: UIButton = .init()
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        makeBorder(color: .black.withAlphaComponent(0.1), width: 1)

        cornerRound(radius: 12)
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        subLabel.textColor = JYPIOSAsset.textB40.color
        
        trailingButton.setImage(JYPIOSAsset.iconAdd.image, for: .normal)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([titleLabel, subLabel, trailingButton])
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
        
        trailingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
    
    func bind(reactor: Reactor) {
        titleLabel.text = "Day \(reactor.currentState.order + 1)"
        subLabel.text = DateManager.dateToString(format: "M월 d일", date: reactor.currentState.date)
    }
}
