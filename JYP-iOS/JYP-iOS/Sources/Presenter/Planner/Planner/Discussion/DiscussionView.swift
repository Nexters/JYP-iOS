//
//  DiscussionView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit
import RxDataSources

class DiscussionView: BaseView, View {
    typealias Reactor = DiscussionReactor
    
    // MARK: - UI Components
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Properties
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<DiscussionSectionModel> { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
        guard let reactor = self?.reactor else { return .init() }
        
        switch item {
        case let .tag(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TagCollectionViewCell.self), for: indexPath) as? TagCollectionViewCell else { return .init() }
            
            cell.reactor = reactor
            
            return cell
        case let .createPikmi(cellReactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CreatePikmiCollectionViewCell.self), for: indexPath) as? CreatePikmiCollectionViewCell else { return .init() }
            
            cell.reactor = cellReactor
            cell.button
                .rx
                .tap
                .map { .tapCreatePikmiButton }
                .bind(to: reactor.action)
                .disposed(by: cell.disposeBag)
            
            return cell
            
        case let .pikmi(cellReactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PikmiCollectionViewCell.self), for: indexPath) as? PikmiCollectionViewCell else { return .init() }
            
            cell.reactor = cellReactor
            cell.infoButton.rx.tap
                .map { .tapPikmiInfoButton(indexPath) }
                .bind(to: reactor.action)
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    } configureSupplementaryView: { [weak self] dataSource, collectionView, _, indexPath -> UICollectionReusableView in
        guard let reactor = self?.reactor else { return .init() }
        
        switch dataSource[indexPath.section].model {
        case .tag:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DiscussionTagSectionHeader.self), for: indexPath) as? DiscussionTagSectionHeader else { return .init() }
            
            return header
        case .pikmi:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PlannerHomeDiscussionCandidatePlaceSectionHeader.self), for: indexPath) as? PlannerHomeDiscussionCandidatePlaceSectionHeader else { return .init() }
            
            header.trailingButton.rx.tap
                .map { .tapCreatePikmiButton }
                .bind(to: reactor.action)
                .disposed(by: header.disposeBag)
            
            return header
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
        
        collectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: TagCollectionViewCell.self))
        collectionView.register(CreatePikmiCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CreatePikmiCollectionViewCell.self))
        collectionView.register(PikmiCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PikmiCollectionViewCell.self))
        collectionView.register(DiscussionTagSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DiscussionTagSectionHeader.self))
        collectionView.register(PlannerHomeDiscussionCandidatePlaceSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PlannerHomeDiscussionCandidatePlaceSectionHeader.self))
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
    
    // MARK: - Bind Method
    
    func bind(reactor: Reactor) {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .map { .selectCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .asObservable()
            .map(\.sections)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension DiscussionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 24, bottom: 48, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch dataSource[indexPath.section].items[indexPath.row] {
        case let .tag(reactor):
            return CGSize(width: reactor.currentState.topic.size(withAttributes: [NSAttributedString.Key.font: JYPIOSFontFamily.Pretendard.medium.font(size: 16)]).width + 50, height: 32)
        case .createPikmi:
            return CGSize(width: collectionView.frame.width - 48, height: 224)
        case .pikmi:
            return CGSize(width: collectionView.frame.width - 48, height: 165)
        }
    }
}
