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
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<JourneyPlanSectionModel> { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
        guard let reactor = self?.reactor else { return .init() }
        
        switch item {
        case let .dayTag(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DayTagColectionViewCell.self), for: indexPath) as? DayTagColectionViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
        case let .journeyPlan(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: JourneyPlanCollectionViewCell.self), for: indexPath) as? JourneyPlanCollectionViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
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
        
        collectionView.register(DayTagColectionViewCell.self, forCellWithReuseIdentifier: String(describing: DayTagColectionViewCell.self))
        collectionView.register(JourneyPlanCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: JourneyPlanCollectionViewCell.self))
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([collectionView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // State
        reactor.state.map(\.sections).asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map(\.sections).asObservable()
            .withUnretained(self)
            .bind { this, sections in
                let layout = this.makeLayout(sections: sections)
                this.collectionView.collectionViewLayout = layout
            }
            .disposed(by: disposeBag)
    }
}

extension JourneyPlanView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 12, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func makeLayout(sections: [JourneyPlanSectionModel]) -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sections[sectionIndex].model {
            case let .dayTag(journeyPlanItems):
                var items: [NSCollectionLayoutItem] = []
                
                journeyPlanItems.forEach({ journeyPlanItem in
                    var item: NSCollectionLayoutItem
                    
                    if case .dayTag = journeyPlanItem {
                        item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(76), heightDimension: .absolute(29)))
                        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 8)
                        
                        items.append(item)
                    }
                })
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.1)), subitems: items)
                group.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
                
            case let .journeyPlan(journeyPlanItems):
                var items: [NSCollectionLayoutItem] = []
                
                journeyPlanItems.forEach({ journeyPlanItem in
                    var height: CGFloat = 72
                    var item: NSCollectionLayoutItem
                    
                    if case let .journeyPlan(reactor) = journeyPlanItem {
                        reactor.currentState.forEach({ sectionModel in
                            if case let .piki(items) = sectionModel.model {
                                if items.isEmpty { return }
                                height = CGFloat(items.count) * 80.0 + CGFloat((items.count - 1)) * 12.0 + 46 + 48
                            }
                        })
                        item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height)))
                        item.contentInsets = .init(top: 0, leading: 0, bottom: 12, trailing: 0)
                        
                        items.append(item)
                    }
                })
                  
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: items)
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            }
        }
        
        return layout
    }
}
