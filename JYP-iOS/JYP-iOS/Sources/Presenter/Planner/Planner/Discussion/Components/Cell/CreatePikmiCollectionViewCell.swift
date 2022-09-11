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
    let imageView: UIImageView = .init(image: JYPIOSAsset.addSubPlace.image)
    let button: JYPButton = .init(type: .addPlace)
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        contentView.backgroundColor = .white
        contentView.setShadow(radius: 40, offset: .init(width: 4, height: 10), opacity: 0.06)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([imageView, button])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(132)
            $0.height.equalTo(101)
        }
        
        button.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(48)
        }
    }
    
    func bind(reactor: Reactor) {
    }
}
