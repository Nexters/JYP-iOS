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
    let dayCollectionViewLayout = UICollectionViewFlowLayout()
    
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<JourneyPlanSectionModel> { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
        guard let reactor = self?.reactor else { return .init() }
        
        switch item {
        case let .dayTag(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DayTagColectionViewCell.self), for: indexPath) as? DayTagColectionViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
        case let .emptyPlan(cellReactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: EmptyPikiCollectionViewCell.self), for: indexPath) as? EmptyPikiCollectionViewCell else { return .init() }
            
            cell.reactor = cellReactor
            cell.trailingButton
                .rx
                .tap
                .map { .tapPlusButton(indexPath) }
                .bind(to: reactor.action)
                .disposed(by: cell.disposeBag)
            return cell
        case let .plan(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PikiCollectionViewCell.self), for: indexPath) as? PikiCollectionViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
        }
    } configureSupplementaryView: { [weak self] dataSource, collectionView, _, indexPath -> UICollectionReusableView in
        guard let reactor = self?.reactor else { return .init() }
        switch dataSource[indexPath.section].model {
        case let .journey(items):
            guard case let .plan(cellReactor) = items[indexPath.item] else { return .init() }
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PikiCollectionReusableView.self), for: indexPath) as? PikiCollectionReusableView else { return .init() }
            
            header.reactor = PikiCollectionReusableViewReactor(order: indexPath.section - 1, date: reactor.currentState.journey?.startDate ?? 0.0)
            
            header.trailingButton.rx.tap
                .map { .tapEditButton(indexPath) }
                .bind(to: reactor.action)
                .disposed(by: header.disposeBag)
            return header
        case .day:
            return .init()
        }
    }

    // MARK: - Initializer
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(reactor: Reactor) {
        super.init(frame: .zero)
        self.reactor = reactor
    }
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        backgroundColor = JYPIOSAsset.backgroundWhite100.color
        
        collectionView.dataSource = dataSource
        collectionView.register(DayTagColectionViewCell.self, forCellWithReuseIdentifier: String(describing: DayTagColectionViewCell.self))
        collectionView.register(EmptyPikiCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: EmptyPikiCollectionViewCell.self))
        collectionView.register(PikiCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PikiCollectionViewCell.self))
        collectionView.register(PikiCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PikiCollectionReusableView.self))
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([collectionView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        reactor.state.map(\.sections)
            .asObservable()
            .withUnretained(self)
            .bind { this, sections in
                this.dataSource.setSections(sections)
                this.collectionView.collectionViewLayout = this.makeLayout(sections: sections)
                this.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}

extension JourneyPlanView {
    func makeLayout(sections: [JourneyPlanSectionModel]) -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch sections[sectionIndex].model {
            case let .day(journeyPlanItems):
                return self?.makeDaySectionLayout(from: journeyPlanItems)
            case let .journey(journeyPlanItems):
                return self?.makeJourneySectionLayout(from: journeyPlanItems)
            }
        }
        
        return layout
    }

    func makeDaySectionLayout(from sectionItems: [JourneyPlanItem]) -> NSCollectionLayoutSection {
        var items: [NSCollectionLayoutItem] = []
        
        sectionItems.forEach({ sectionItem in
            var item: NSCollectionLayoutItem
            
            if case .dayTag = sectionItem {
                item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(76), heightDimension: .absolute(29)))
                item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 8)
                
                items.append(item)
            }
        })
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(29)), subitems: items)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = .init(top: 28, leading: 20, bottom: 40, trailing: 20)
        
        return section
    }
    
    func makeJourneySectionLayout(from sectionItems: [JourneyPlanItem]) -> NSCollectionLayoutSection {
        var items: [NSCollectionLayoutItem] = []
        
        sectionItems.forEach({ sectionItem in
            switch sectionItem {
            case .dayTag: break
            case .emptyPlan:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(72)))
                
                items.append(item)
            case .plan:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(92)))
                
                items.append(item)
            }
        })
          
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300)), subitems: items)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 20, bottom: 12, trailing: 20)
        
        var isHeader = true
        
        sectionItems.forEach({ item in
            if case .plan = item {} else {
                isHeader = false
            }
        })
        
        if isHeader && sectionItems.count >= 1 {
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            section.boundarySupplementaryItems = [header]
        }
        
        return section
    }
}
