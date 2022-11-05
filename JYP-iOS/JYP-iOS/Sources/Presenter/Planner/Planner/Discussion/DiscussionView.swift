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
    // MARK: - Constants
    
    private enum UI {
        static let topMargin: CGFloat = 28
        static let cellWidthMargin: CGFloat = 48
        static let cellTopMargin: CGFloat = 8
        static let tagCellHeight: CGFloat = 32
        static let pikmiCellHeight: CGFloat = 165
        static let createPikmiCellHeight: CGFloat = 224
        static let headerHeight: CGFloat = 60
        static let sectionMargin: UIEdgeInsets = .init(top: 0, left: 24, bottom: 48, right: 24)
    }
    
    typealias Reactor = DiscussionReactor
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<DiscussionSectionModel>
    
    // MARK: - Properties
    
    private lazy var dataSource = DataSource { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
        guard let thisReactor = self?.reactor else { return .init() }
        
        switch item {
        case let .tag(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TagCollectionViewCell.self), for: indexPath) as? TagCollectionViewCell else { return .init() }
            cell.reactor = reactor
            return cell
            
        case .emptyTag:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: EmptyTagCollectionViewCell.self), for: indexPath) as? EmptyTagCollectionViewCell else { return .init() }
            return cell
            
        case let .pikmi(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PikmiCollectionViewCell.self), for: indexPath) as? PikmiCollectionViewCell else { return .init() }
            cell.reactor = reactor
            cell.infoButton.rx.tap
                .map { .tapPikmiCellInfoButton(indexPath) }
                .bind(to: thisReactor.action)
                .disposed(by: cell.disposeBag)
            return cell
            
        case let .createPikmi(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CreatePikmiCollectionViewCell.self), for: indexPath) as? CreatePikmiCollectionViewCell else { return .init() }
            cell.reactor = reactor
            cell.button.rx.tap
                .map { .tapCreatePikmiCellButton(indexPath) }
                .bind(to: thisReactor.action)
                .disposed(by: cell.disposeBag)
            return cell
        }
    } configureSupplementaryView: { [weak self] dataSource, collectionView, _, indexPath -> UICollectionReusableView in
        guard let thisReactor = self?.reactor else { return .init() }
        
        switch dataSource[indexPath.section].model {
        case .tag:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DiscussionTagSectionHeader.self), for: indexPath) as? DiscussionTagSectionHeader else { return .init() }
            header.toggleButton.rx.tap
                .map { .tapToggleButton }
                .bind(to: thisReactor.action)
                .disposed(by: header.disposeBag)
            thisReactor.state
                .map(\.isToggleOn)
                .bind(to: header.toggleButton.rx.isSelected)
                .disposed(by: header.disposeBag)
            return header
            
        case .pikmi:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DiscussionPikmiSectionHeader.self), for: indexPath) as? DiscussionPikmiSectionHeader else { return .init() }
            header.trailingButton.rx.tap
                .map { .tapPlusButton }
                .bind(to: thisReactor.action)
                .disposed(by: header.disposeBag)
            return header
        }
    }
    
    // MARK: - UI Components
    
    let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
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
        collectionView.register(EmptyTagCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: EmptyTagCollectionViewCell.self))
        collectionView.register(CreatePikmiCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CreatePikmiCollectionViewCell.self))
        collectionView.register(PikmiCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PikmiCollectionViewCell.self))
        collectionView.register(DiscussionTagSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DiscussionTagSectionHeader.self))
        collectionView.register(DiscussionPikmiSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: DiscussionPikmiSectionHeader.self))
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([collectionView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(UI.topMargin)
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
            .map(\.sections)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension DiscussionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: UI.headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UI.sectionMargin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return UI.cellTopMargin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UI.cellTopMargin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch dataSource[indexPath.section].items[indexPath.row] {
        case let .tag(reactor):
            return CGSize(width: reactor.currentState.topic.size(withAttributes: [NSAttributedString.Key.font: JYPIOSFontFamily.Pretendard.medium.font(size: 16)]).width + 50, height: UI.tagCellHeight)
        case .emptyTag:
            return CGSize(width: 0, height: 0)
        case .pikmi:
            return CGSize(width: collectionView.frame.width - UI.cellWidthMargin, height: UI.pikmiCellHeight)
            
        case .createPikmi:
            return CGSize(width: collectionView.frame.width - UI.cellWidthMargin, height: UI.createPikmiCellHeight)
        }
    }
}
