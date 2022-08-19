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
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<JourneyPlanSectionModel> { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
        guard let reactor = self?.reactor else { return .init() }
        
        switch item {
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
        
        backgroundColor = .orange
        
        collectionView.register(JourneyPlanCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: JourneyPlanCollectionViewCell.self))
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([collectionView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // State
        reactor.state.map(\.sections).asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension JourneyPlanView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 0, bottom: 12, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch dataSource[indexPath.section].items[indexPath.row] {
        case let .journeyPlan(reactor):
            var height: CGFloat = 72
            
            reactor.currentState.forEach({ sectionModel in
                switch sectionModel.model {
                case let .piki(items):
                    if items.isEmpty { break }
                    height = CGFloat(items.count) * 80.0 + CGFloat((items.count - 1)) * 12.0 + 46
                }
            })
            
            return CGSize(width: collectionView.bounds.width, height: height)
        }
    }
}
