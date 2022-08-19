//
//  JourneyPlanCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/18.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit
import RxDataSources

class JourneyPlanCollectionViewCell: BaseCollectionViewCell, View {
    typealias Reactor = JourneyPlanCollectionViewCellReactor
    
    let leftView = UIView()
    let collectionView = UICollectionView()
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<JourneyPlaceSectionModel> { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
        guard let reactor = self?.reactor else { return .init() }
        
        switch item {
        case let .journeyPlace(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: JourneyPlaceCollectionViewCell.self), for: indexPath) as? JourneyPlaceCollectionViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
        }
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        leftView.backgroundColor = .blue
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([leftView, collectionView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        leftView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(50)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(leftView.snp.trailing)
        }
    }
    
    func bind(reactor: Reactor) {    
    }
}
