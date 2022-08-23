//
//  DayTagCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/20.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class DayTagCollectionViewCellReactor: Reactor {
    enum Action {}
    enum Mutation {}
    
    struct State {
        let day: Int
    }
    
    var initialState: State
    
    init(state: State) {
        self.initialState = state
    }
}

class DayTagColectionViewCell: BaseCollectionViewCell, View {
    typealias Reactor = DayTagCollectionViewCellReactor
    
    // MARK: - UI Components
    
    let dayLabel: UILabel = .init()
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        contentView.backgroundColor = JYPIOSAsset.tagWhiteGrey100.color
        contentView.cornerRound(radius: 8)
        
        dayLabel.font = JYPIOSFontFamily.Pretendard.bold.font(size: 14)
        dayLabel.textColor = JYPIOSAsset.textB80.color
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([dayLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        dayLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Bind Method
    
    func bind(reactor: Reactor) {
        dayLabel.text =  "Day \(reactor.currentState.day)"
    }
}
