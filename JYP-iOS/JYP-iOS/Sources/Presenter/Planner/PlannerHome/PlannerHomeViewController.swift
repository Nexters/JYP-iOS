//
//  DiscussionHomeViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/04.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit
import RxDataSources

class PlannerHomeViewController: NavigationBarViewController, View {
    typealias Reactor = PlannerHomeReactor

    let dateLabel = UILabel()
    let inviteButton = UIButton()
    let bottomView = UIView()
    let discussionButton = UIButton()
    let planerButton = UIButton()
    let discussionView = UIView()
    let planerView = UIView()
    let discussionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reactor = PlannerHomeReactor()
    }
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<PlannerHomeDiscussionSectionModel> { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case let .jypTagItem(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: JYPTagCollectionViewCell.self), for: indexPath) as? JYPTagCollectionViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
        case let .candidatePlaceItem(reactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CandidatePlaceCollectionViewCell.self), for: indexPath) as? CandidatePlaceCollectionViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
        }
    } configureSupplementaryView: { dataSource, collectionView, _, indexPath -> UICollectionReusableView in
        switch dataSource[indexPath.section].model {
        case .jypTagSection:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PlannerHomeDiscussionJYPTagSectionHeader.self), for: indexPath) as? PlannerHomeDiscussionJYPTagSectionHeader else { return .init() }
            
            return header
        case .candidatePlaceSection:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PlannerHomeDiscussionCandidatePlaceSectionHeader.self), for: indexPath) as? PlannerHomeDiscussionCandidatePlaceSectionHeader else { return .init() }
            
            return header
        }
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        view.backgroundColor = JYPIOSAsset.backgroundGrey300.color
        
        dateLabel.text = "7월 18일 - 7월 20일"
        dateLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        dateLabel.textColor = JYPIOSAsset.textWhite.color
        
        inviteButton.setTitle("일행 초대하기", for: .normal)
        inviteButton.setTitleColor(.white, for: .normal)
        inviteButton.titleLabel?.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
        inviteButton.backgroundColor = JYPIOSAsset.mainPink.color
        inviteButton.setImage(JYPIOSAsset.inviteFriend.image, for: .normal)
        inviteButton.cornerRound(radius: 10)
        
        bottomView.backgroundColor = JYPIOSAsset.backgroundWhite100.color
        bottomView.cornerRound(radius: 20, direct: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        discussionButton.setTitle("토론장", for: .normal)
        discussionButton.setTitleColor(JYPIOSAsset.textB80.color, for: .normal)
        discussionButton.titleLabel?.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 18)
        
        planerButton.setTitle("여행 계획", for: .normal)
        planerButton.setTitleColor(JYPIOSAsset.textB80.color, for: .normal)
        planerButton.titleLabel?.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 18)
        
        discussionCollectionView.showsVerticalScrollIndicator = false
        discussionCollectionView.register(JYPTagCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: JYPTagCollectionViewCell.self))
        discussionCollectionView.register(CandidatePlaceCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CandidatePlaceCollectionViewCell.self))
        discussionCollectionView.register(PlannerHomeDiscussionJYPTagSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PlannerHomeDiscussionJYPTagSectionHeader.self))
        discussionCollectionView.register(PlannerHomeDiscussionCandidatePlaceSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PlannerHomeDiscussionCandidatePlaceSectionHeader.self))
    }
    
    override func setupDelegate() {
        super.setupDelegate()
        
        discussionCollectionView.delegate = self
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([dateLabel, inviteButton, bottomView])
        
        bottomView.addSubviews([discussionButton, planerButton, discussionView])
        
        discussionView.addSubview(discussionCollectionView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        
        inviteButton.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(133)
            $0.height.equalTo(40)
        }
        
        bottomView.snp.makeConstraints {
            $0.top.equalTo(inviteButton.snp.bottom).offset(13)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        discussionButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(24)
        }
        
        planerButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalTo(discussionButton.snp.trailing).offset(28)
        }
        
        discussionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(61)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        discussionCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        setNavigationBarBackgroundColor(JYPIOSAsset.backgroundGrey300.color)
        setNavigationBarTitleText("강릉 여행기")
        setNavigationBarTitleTextColor(JYPIOSAsset.textWhite.color)
        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.semiBold.font(size: 20))
    }
    
    override func setupBind() {
        super.setupBind()
        
        inviteButton.rx.tap
            .bind { [weak self] _ in
                let discussionInviteVC = PlannerInviteViewController()
                self?.navigationController?.pushViewController(discussionInviteVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func bind(reactor: Reactor) {
        reactor.state.map(\.sections).asObservable()
            .bind(to: discussionCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension PlannerHomeViewController: UICollectionViewDelegateFlowLayout {
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
        case .jypTagItem(let reactor):
            return CGSize(width: reactor.currentState.text.size(withAttributes: [NSAttributedString.Key.font: JYPIOSFontFamily.Pretendard.medium.font(size: 16)]).width + 50, height: 32)
        case .candidatePlaceItem:
            return CGSize(width: collectionView.frame.width - 48, height: 165)
        }
    }
}
