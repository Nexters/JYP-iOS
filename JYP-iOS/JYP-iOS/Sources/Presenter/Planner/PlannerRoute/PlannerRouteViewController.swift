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
    
    // MARK: - Properties
    
    typealias Reactor = PlannerRouteReactor
    
    private lazy var routeDataSource = RxCollectionViewSectionedReloadDataSource<RouteSectionModel> { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case let .route(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: RouteCollectionViewCell.self), for: indexPath) as? RouteCollectionViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
        }
    }
    
    private lazy var pikmiRouteDataSource = RxCollectionViewSectionedReloadDataSource<PikmiRouteSectionModel> { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case let .pikmiRoute(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PikmiRouteCollectionViewCell.self), for: indexPath) as? PikmiRouteCollectionViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
        }
    } configureSupplementaryView: { dataSource, collectionView, _, indexPath in
        switch dataSource[indexPath.section].model {
        case .pikmiRoute:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PikmiRouteCollectionReusableView.self), for: indexPath) as? PikmiRouteCollectionReusableView else { return .init() }
            
            return header
        }
    }
    
    // MARK: - UI Components
    
    let emptyLabel: UILabel = .init()
    let routeCollectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let pikmiRouteCollectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let doneButton: JYPButton = .init(type: .done)
    
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
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        emptyLabel.text = "방문할 장소를 선택해 주세요"
        emptyLabel.textColor = JYPIOSAsset.textB40.color
        emptyLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 16)
        
        routeCollectionView.backgroundColor = JYPIOSAsset.backgroundWhite200.color
        routeCollectionView.register(RouteCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: RouteCollectionViewCell.self))
        
        pikmiRouteCollectionView.backgroundColor = .clear
        pikmiRouteCollectionView.register(PikmiRouteCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PikmiRouteCollectionViewCell.self))
        pikmiRouteCollectionView.register(RouteCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: RouteCollectionViewCell.self))
        pikmiRouteCollectionView.register(PikmiRouteCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PikmiRouteCollectionReusableView.self))
        
        doneButton.isEnabled = true
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([routeCollectionView, pikmiRouteCollectionView, doneButton])
        routeCollectionView.addSubviews([emptyLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        routeCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(140)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        pikmiRouteCollectionView.snp.makeConstraints {
            $0.top.equalTo(routeCollectionView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(34)
            $0.height.equalTo(52)
        }
    }
    
    func bind(reactor: Reactor) {
        rx.viewWillAppear
            .map { _ in .refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        routeCollectionView.rx.itemSelected
            .map { .tapRouteCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        pikmiRouteCollectionView.rx.itemSelected
            .map { .tapPikmiRouteCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .map { .tapDoneButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.order)
            .withUnretained(self)
            .bind { this, order in
                this.setNavigationBarTitleText("DAY \(order + 1)")
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.date)
            .withUnretained(self)
            .bind { this, date in
                this.setNavigationBarSubTitleText(DateManager.dateToString(format: "M월 d일", date: date))
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.routeSections)
            .withUnretained(self)
            .bind { this, sections in
                let layout = this.makeRouteLayout(sections: sections)
                this.routeCollectionView.collectionViewLayout = layout
                
                if let section = sections.first {
                    this.emptyLabel.isHidden = !section.items.isEmpty
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.routeSections)
            .bind(to: routeCollectionView.rx.items(dataSource: routeDataSource))
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
        
        reactor.state
            .map(\.isDone)
            .filter { $0 }
            .withUnretained(self)
            .bind { this, _ in
                this.navigationController?.dismiss(animated: true)
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
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(136), heightDimension: .absolute(78)))
                
                item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 16)
                items.append(item)
            }
        })
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(300), heightDimension: .estimated(300)), subitems: items)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = .init(top: 31, leading: 24, bottom: 31, trailing: 24)
        
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
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        header.contentInsets = .init(top: -28, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 0, leading: 24, bottom: 0, trailing: 24)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}
