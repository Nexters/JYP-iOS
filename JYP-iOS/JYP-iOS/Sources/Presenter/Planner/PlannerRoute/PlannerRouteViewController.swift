//
//  PlannerRouteViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit
import RxDataSources

class PlannerRouteViewController: NavigationBarViewController, View {
    typealias Reactor = PlannerRouteReactor
    
    // MARK: - UI Components
    
    let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Properties
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<PlannerRouteSectionModel> { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case let .route(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RouteCollectionViewCell.self), for: indexPath) as? RouteCollectionViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
            
        case let .pikmiRoute(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PikmiRouteCollectionViewCell.self), for: indexPath) as? PikmiRouteCollectionViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
        }
    }
    
    // MARK: - Initializer
    
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        setNavigationBarTitleText("DAY 1")
        setNavigationBarSubTitleText("7월 18일")
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        collectionView.register(PikmiRouteCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PikmiRouteCollectionViewCell.self))
        collectionView.register(RouteCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: RouteCollectionViewCell.self))
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([collectionView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        rx.viewWillAppear
            .map { _ in .refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.sections)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
