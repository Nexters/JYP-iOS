//
//  JourneyPlanView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/18.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit
import RxDataSources

class JourneyPlanView: BaseView, View {
    typealias Reactor = JourneyPlanReactor
    
    // MARK: - UI Components
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Properties
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<JourneyPlanSectionModel> { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
        guard let reactor = self?.reactor else { return .init() }
        
        switch item {
        case let .journeyPlan(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: JourneyPlanCollectionViewCell.self), for: indexPath) as? JourneyPlanCollectionViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
        }
    }
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        backgroundColor = .orange
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([collectionView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        // State
        reactor.state.map(\.sections).asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
