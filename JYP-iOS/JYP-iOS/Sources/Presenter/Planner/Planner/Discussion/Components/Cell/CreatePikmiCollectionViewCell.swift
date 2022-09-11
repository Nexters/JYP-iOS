//
//  CreateCandidatePlaceCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/12.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class CreatePikmiCollectionViewCell: BaseCollectionViewCell, View {
    typealias Reactor = CreatePikmiCollectionViewCellReactor
    
    // MARK: - UI Components
    
    let button: JYPButton = .init(type: .addPlace)
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
    }
    
    func bind(reactor: Reactor) {
        
    }
}
