//
//  RouteCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class RouteCollectionViewCell: BaseCollectionViewCell, View {
    typealias Reactor = RouteCollectionViewCellReactor
    
    // MARK: - UI Components
    
    let subLabel: UILabel = .init()
    let titleLabel: UILabel = .init()
    let deleteButton: UIButton = .init()
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([subLabel, titleLabel, deleteButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        
    }
    
    // MARK: - Bind Method
    
    func bind(reactor: Reactor) {
        
    }
}
