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
    
    // MARK: - UI Components
    
    let headerView: UIView = .init()
    let titleLabel: UILabel = .init()
    let subLabel: UILabel = .init()
    let editButton: UIButton = .init()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var emptyPikiView: EmptyPikiView = .init(title: "Day 1", sub: "8월 20일")
    let lineView = UIView()
    
    // MARK: - Properties
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<PikiSectionModel> { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
        guard let reactor = self?.reactor else { return .init() }
        
        switch item {
        case let .piki(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PikiCollectionViewCell.self), for: indexPath) as? PikiCollectionViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
        }
    }
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        titleLabel.text = "Day1"
        
        subLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        subLabel.textColor = JYPIOSAsset.textB40.color
        subLabel.text = "7월 18일"
        
        editButton.setImage(JYPIOSAsset.iconModify.image, for: .normal)
        
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(PikiCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PikiCollectionViewCell.self))
        
        lineView.backgroundColor = JYPIOSAsset.tagWhiteGrey100.color
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([headerView, lineView, collectionView, emptyPikiView])
        
        headerView.addSubviews([titleLabel, subLabel, editButton])
    }

    override func setupLayout() {
        super.setupLayout()
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(46)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(14)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(26)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        
        emptyPikiView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.top)
            $0.leading.equalToSuperview().inset(34)
            $0.height.equalTo(0)
            $0.width.equalTo(1)
        }
    }
    
    // MARK: - Bind Method
    
    func bind(reactor: Reactor) {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        reactor.state
            .asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        guard let items = reactor.currentState.first?.items else { return }
        
        emptyPikiView.isHidden = !items.isEmpty
        emptyPikiView.isUserInteractionEnabled = items.isEmpty
        
        lineView.isHidden = items.isEmpty
        headerView.isHidden = items.isEmpty
        
        let height = CGFloat(items.count) * 80.0 + CGFloat((items.count - 1)) * 12.0
        
        lineView.snp.updateConstraints {
            $0.height.equalTo(abs(height))
        }
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
            return CGSize(width: collectionView.bounds.width - 48, height: 80)
        }
    }
}
