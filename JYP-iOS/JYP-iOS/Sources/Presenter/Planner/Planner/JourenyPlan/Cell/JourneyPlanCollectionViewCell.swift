//
//  JourneyPlanCollectionViewCell.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/18.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit
import RxDataSources

class JourneyPlanCollectionViewCell: BaseCollectionViewCell, View {
    typealias Reactor = JourneyPlanCollectionViewCellReactor
    
    let leftView = UIView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<PikiSectionModel> { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
        guard let reactor = self?.reactor else { return .init() }
        
        switch item {
        case let .piki(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PikiCollectionViewCell.self), for: indexPath) as? PikiCollectionViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
        }
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        leftView.backgroundColor = .blue
        
        collectionView.isScrollEnabled = false
        
        collectionView.register(PikiCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PikiCollectionViewCell.self))
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([leftView, collectionView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        leftView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(50)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(leftView.snp.trailing)
        }
    }
    
    func bind(reactor: Reactor) {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        reactor.state
            .asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        print(reactor.currentState[0].items.count)
    }
}

extension JourneyPlanCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 24, bottom: 12, right: 24)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch dataSource[indexPath.section].items[indexPath.row] {
        case .piki:
            return CGSize(width: collectionView.bounds.width, height: 80)
        }
    }
}
