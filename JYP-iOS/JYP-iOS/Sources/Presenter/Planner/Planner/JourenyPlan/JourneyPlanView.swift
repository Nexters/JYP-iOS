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
    
    // MARK: - Properties
    
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<JourneyPlanSectionModel> { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
        guard let reactor = self?.reactor else { return .init() }
        
        switch item {
        case let .emptyPlan(cellReactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: EmptyPikiCollectionViewCell.self), for: indexPath) as? EmptyPikiCollectionViewCell else { return .init() }
            
            cell.reactor = cellReactor
            cell.trailingButton.rx.tap
                .map { .tapPlusButton(indexPath, cellReactor.currentState) }
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
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PikiCollectionReusableView.self), for: indexPath) as? PikiCollectionReusableView else { return .init() }
            
            let index = indexPath.section
            let date = Date(timeIntervalSince1970: reactor.currentState.journey?.startDate ?? Date.timeIntervalBetween1970AndReferenceDate)
            
            let cellReactor = PikiCollectionReusableViewReactor(index: index, date: date)
            header.reactor = cellReactor
            
            header.trailingButton.rx.tap
                .map { .tapEditButton(indexPath, cellReactor.currentState) }
                .bind(to: reactor.action)
                .disposed(by: header.disposeBag)
            return header
        }
    }
    
    // MARK: - UI Components
    
    let dayScrollView: UIScrollView = .init()
    let dayStackView: UIStackView = .init()
    var dayButtons: [UIButton] = [] {
        didSet {
            dayStackView.removeArrangedSubviews()
            
            dayButtons.enumerated().forEach({ index, button in
                button.setTitleColor(JYPIOSAsset.textB80.color, for: .normal)
                button.titleLabel?.font = JYPIOSFontFamily.Pretendard.bold.font(size: 14)
                button.backgroundColor = JYPIOSAsset.tagWhiteGrey100.color
                button.cornerRound(radius: 8)
                
                button.snp.makeConstraints {
                    $0.width.equalTo(76)
                    $0.height.equalTo(29)
                }
                
                if let reactor = reactor {
                    button.rx.tap.map { .tapDayButton(index) }
                        .bind(to: reactor.action)
                        .disposed(by: disposeBag)
                }
                
                dayStackView.addArrangedSubview(button)
            })
        }
    }
    
    let refreshControl: UIRefreshControl = .init()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

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
        
        dayStackView.spacing = 8
        
        refreshControl.transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        collectionView.refreshControl = refreshControl
        collectionView.dataSource = dataSource
        
        collectionView.register(DayTagColectionViewCell.self, forCellWithReuseIdentifier: String(describing: DayTagColectionViewCell.self))
        collectionView.register(EmptyPikiCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: EmptyPikiCollectionViewCell.self))
        collectionView.register(PikiCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PikiCollectionViewCell.self))
        collectionView.register(PikiCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PikiCollectionReusableView.self))
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([dayScrollView, collectionView])
        dayScrollView.addSubviews([dayStackView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        dayScrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        dayStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(dayScrollView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        refreshControl.rx.controlEvent(.valueChanged)
            .map { .fetch }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap(\.journey)
            .subscribe(onNext: { [weak self] journey in
                let buttons = journey.pikidays.enumerated().map { (index, _) -> UIButton in
                    let button: UIButton = .init(type: .system)
                    button.setTitle("Day \(index + 1)", for: .normal)
                    return button
                }
                self?.dayButtons = buttons
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.sections)
            .withUnretained(self)
            .bind { this, sections in
                this.collectionView.refreshControl?.endRefreshing()
                this.dataSource.setSections(sections)
                this.collectionView.collectionViewLayout = this.makeLayout(sections: sections)
                this.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap(\.scrollSection)
            .subscribe(onNext: { [weak self] section in
                self?.collectionView.scrollToItem(at: IndexPath(row: 0, section: section), at: .top, animated: true)
                self?.dayButtons.enumerated().forEach({ index, button in
                    if index == section {
                        button.setTitleColor(.white, for: .normal)
                        button.backgroundColor = JYPIOSAsset.mainPink.color
                    } else {
                        button.setTitleColor(JYPIOSAsset.textB80.color, for: .normal)
                        button.backgroundColor = JYPIOSAsset.tagWhiteGrey100.color
                    }
                })
            })
            .disposed(by: disposeBag)
    }
}

extension JourneyPlanView {
    func makeLayout(sections: [JourneyPlanSectionModel]) -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            switch sections[sectionIndex].model {
            case let .journey(journeyPlanItems):
                return self?.makeJourneySectionLayout(from: journeyPlanItems)
            }
        }
        
        return layout
    }
    
    func makeJourneySectionLayout(from sectionItems: [JourneyPlanItem]) -> NSCollectionLayoutSection {
        var items: [NSCollectionLayoutItem] = []
        
        sectionItems.forEach({ sectionItem in
            switch sectionItem {
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
