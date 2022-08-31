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
    
    let emptyView: UIView = .init()
    let routeCollectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let pikmiRouteCollectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Properties
    
    private lazy var pikmiRouteDataSource = RxCollectionViewSectionedReloadDataSource<PikmiRouteSectionModel> { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case let .pikmiRoute(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PikmiRouteCollectionViewCell.self), for: indexPath) as? PikmiRouteCollectionViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
        }
    }
    
    private lazy var routeDataSource = RxCollectionViewSectionedReloadDataSource<RouteSectionModel> { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case let .route(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RouteCollectionViewCell.self), for: indexPath) as? RouteCollectionViewCell else { return .init() }
            
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
        
        routeCollectionView.backgroundColor = JYPIOSAsset.backgroundWhite200.color
        
        pikmiRouteCollectionView.backgroundColor = .clear
        pikmiRouteCollectionView.register(PikmiRouteCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PikmiRouteCollectionViewCell.self))
        pikmiRouteCollectionView.register(RouteCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: RouteCollectionViewCell.self))
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([routeCollectionView, pikmiRouteCollectionView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        routeCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(140)
        }
        
        pikmiRouteCollectionView.snp.makeConstraints {
            $0.top.equalTo(routeCollectionView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        rx.viewWillAppear
            .map { _ in .refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.routeSections)
            .bind(to: routeCollectionView.rx.items(dataSource: routeDataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.routeSections)
            .withUnretained(self)
            .bind { this, sections in
                let layout = this.makeRouteLayout(sections: sections)
                this.routeCollectionView.collectionViewLayout = layout
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.pikmiRouteSections)
            .bind(to: pikmiRouteCollectionView.rx.items(dataSource: pikmiRouteDataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.pikmiRouteSections)
            .withUnretained(self)
            .bind { this, sections in
                let layout = this.makePikmiRouteLayout(sections: sections)
                this.pikmiRouteCollectionView.collectionViewLayout = layout
            }
            .disposed(by: disposeBag)
    }
}

extension PlannerRouteViewController {
    func makeRouteLayout(sections: [RouteSectionModel]) -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch sections[sectionIndex].model {
            case let .route(items):
                return self?.makeRouteSectionLayout(from: items)
            }
        }
        return layout
    }
    
    func makePikmiRouteLayout(sections: [PikmiRouteSectionModel]) -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch sections[sectionIndex].model {
            case let .pikmiRoute(items):
                return self?.makePikmiRouteSectionLayout(from: items)
            }
        }
        return layout
    }
    
    func makeRouteSectionLayout(from sectionItems: [RouteItem]) -> NSCollectionLayoutSection? {
        if sectionItems.isEmpty {
            return nil
        }
        
        var items: [NSCollectionLayoutItem] = []
        
        sectionItems.forEach({ sectionItem in
            switch sectionItem {
            case .route:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(100), heightDimension: .estimated(200)))
                
                items.append(item)
            }
        })
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300)), subitems: items)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func makePikmiRouteSectionLayout(from sectionItems: [PikmiRouteItem]) -> NSCollectionLayoutSection? {
        if sectionItems.isEmpty {
            return nil
        }
        
        var items: [NSCollectionLayoutItem] = []
        
        sectionItems.forEach({ sectionItem in
            switch sectionItem {
            case .pikmiRoute:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(72)))
                
                item.edgeSpacing = .init(leading: .none, top: .none, trailing: .none, bottom: .fixed(12))
                
                items.append(item)
            }
        })
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: items)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)
        
        return section
    }
}
