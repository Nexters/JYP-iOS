//
//  ScheduledJourneyView.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/16.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit
import RxDataSources

final class ScheduledJourneyView: BaseView, View {
    typealias Reactor = ScheduledJourneyReactor
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<ScheduledJourneySectionModel>
    
    // MARK: - UI Components
    
    private let layout: UICollectionViewLayout = .init()
    private lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)
    
    // MARK: - Properties
    
    private lazy var dataSource = DataSource { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case .empty: return .init()
        case .journey: return .init()
        }
    }

    // MARK: - Initializer

    init(reactor: Reactor) {
        super.init(frame: .zero)
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupProperty() {
        super.setupProperty()

        backgroundColor = JYPIOSAsset.tagOrange300.color
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubview(collectionView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func bind(reactor _: ScheduledJourneyReactor) {}
}
