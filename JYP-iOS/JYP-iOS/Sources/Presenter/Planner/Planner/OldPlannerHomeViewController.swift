////
////  DiscussionHomeViewController.swift
////  JYP-iOS
////
////  Created by 송영모 on 2022/08/04.
////  Copyright © 2022 JYP-iOS. All rights reserved.
////
//
//import UIKit
//import ReactorKit
//import RxDataSources
//import RxCocoa
//
//class OldPlannerHomeViewController: NavigationBarViewController, View {
//    typealias Reactor = OldPlannerHomeReactor
//
//    let dateLabel = UILabel()
//    let inviteButton = UIButton()
//    let bottomView = UIView()
//    let discussionButton = UIButton()
//    let planerButton = UIButton()
//    let discussionView = UIView()
//    let planerView = UIView()
//    let discussionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//                                          
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.reactor = OldPlannerHomeReactor()
//    }
//    
//    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<OldPlannerHomeDiscussionSectionModel> { [weak self] _, collectionView, indexPath, item -> UICollectionViewCell in
//        guard let reactor = self?.reactor else { return .init() }
//        
//        switch item {
//        case let .jypTagItem(reactor):
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: JYPTagCollectionViewCell.self), for: indexPath) as? JYPTagCollectionViewCell else { return .init() }
//            
//            cell.reactor = reactor
//            return cell
//        case let .createCandidatePlaceItem(cellReactor):
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CreatePikmiCollectionViewCell.self), for: indexPath) as? CreatePikmiCollectionViewCell else { return .init() }
//            
//            cell.reactor = cellReactor
//            return cell
//        case let .candidatePlaceItem(cellReactor):
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PikmiCollectionViewCell.self), for: indexPath) as? PikmiCollectionViewCell else { return .init() }
//            
//            cell.reactor = cellReactor
//            
//            cell.infoButton.rx.tap
//                .map { .didTapCandidatePlaceInfoButton(indexPath) }
//                .bind(to: reactor.action)
//                .disposed(by: cell.disposeBag)
//            
//            cell.likeButton.rx.tap
//                .map { .didTapCandidatePlaceLikeButton(indexPath) }
//                .bind(to: reactor.action)
//                .disposed(by: cell.disposeBag)
//            
//            return cell
//        }
//    } configureSupplementaryView: { [weak self] dataSource, collectionView, _, indexPath -> UICollectionReusableView in
//        guard let reactor = self?.reactor else { return .init() }
//        
//        switch dataSource[indexPath.section].model {
//        case .jypTagSection:
//            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PlannerHomeDiscussionJYPTagSectionHeader.self), for: indexPath) as? PlannerHomeDiscussionJYPTagSectionHeader else { return .init() }
//            
//            return header
//        case .candidatePlaceSection:
//            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PlannerHomeDiscussionCandidatePlaceSectionHeader.self), for: indexPath) as? PlannerHomeDiscussionCandidatePlaceSectionHeader else { return .init() }
//            
//            header.trailingButton.rx.tap
//                .map { .didTapAddCandidatePlaceButton }
//                .bind(to: reactor.action)
//                .disposed(by: header.disposeBag)
//            
//            return header
//        }
//    }
//    
//    override func setupProperty() {
//        super.setupProperty()
//        
//        view.backgroundColor = JYPIOSAsset.backgroundGrey300.color
//        
//        dateLabel.text = "7월 18일 - 7월 20일"
//        dateLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
//        dateLabel.textColor = JYPIOSAsset.textWhite.color
//        
//        inviteButton.setTitle("일행 초대하기", for: .normal)
//        inviteButton.setTitleColor(.white, for: .normal)
//        inviteButton.titleLabel?.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
//        inviteButton.backgroundColor = JYPIOSAsset.mainPink.color
//        inviteButton.setImage(JYPIOSAsset.inviteFriend.image, for: .normal)
//        inviteButton.cornerRound(radius: 10)
//        
//        bottomView.backgroundColor = JYPIOSAsset.backgroundWhite100.color
//        bottomView.cornerRound(radius: 20, direct: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
//        
//        discussionButton.setTitle("토론장", for: .normal)
//        discussionButton.setTitleColor(JYPIOSAsset.textB80.color, for: .normal)
//        discussionButton.titleLabel?.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 18)
//        
//        planerButton.setTitle("여행 계획", for: .normal)
//        planerButton.setTitleColor(JYPIOSAsset.textB80.color, for: .normal)
//        planerButton.titleLabel?.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 18)
//        
//        discussionCollectionView.showsVerticalScrollIndicator = false
//        discussionCollectionView.register(JYPTagCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: JYPTagCollectionViewCell.self))
//        discussionCollectionView.register(PikmiCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PikmiCollectionViewCell.self))
//        discussionCollectionView.register(PlannerHomeDiscussionJYPTagSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PlannerHomeDiscussionJYPTagSectionHeader.self))
//        discussionCollectionView.register(PlannerHomeDiscussionCandidatePlaceSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PlannerHomeDiscussionCandidatePlaceSectionHeader.self))
//    }
//    
//    override func setupDelegate() {
//        super.setupDelegate()
//        
//        discussionCollectionView.delegate = self
//    }
//    
//    override func setupHierarchy() {
//        super.setupHierarchy()
//        
//        contentView.addSubviews([dateLabel, inviteButton, bottomView])
//        
//        bottomView.addSubviews([discussionButton, planerButton, discussionView])
//        
//        discussionView.addSubview(discussionCollectionView)
//    }
//    
//    override func setupLayout() {
//        super.setupLayout()
//        
//        dateLabel.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(12)
//            $0.leading.equalToSuperview().inset(24)
//        }
//        
//        inviteButton.snp.makeConstraints {
//            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
//            $0.leading.equalToSuperview().inset(24)
//            $0.width.equalTo(133)
//            $0.height.equalTo(40)
//        }
//        
//        bottomView.snp.makeConstraints {
//            $0.top.equalTo(inviteButton.snp.bottom).offset(13)
//            $0.leading.trailing.bottom.equalToSuperview()
//        }
//        
//        discussionButton.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(28)
//            $0.leading.equalToSuperview().inset(24)
//        }
//        
//        planerButton.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(28)
//            $0.leading.equalTo(discussionButton.snp.trailing).offset(28)
//        }
//        
//        discussionView.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(61)
//            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalToSuperview()
//        }
//        
//        discussionCollectionView.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(28)
//            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalToSuperview()
//        }
//    }
//    
//    override func setupNavigationBar() {
//        super.setupNavigationBar()
//        
//        setNavigationBarBackgroundColor(JYPIOSAsset.backgroundGrey300.color)
//        setNavigationBarTitleText("강릉 여행기")
//        setNavigationBarTitleTextColor(JYPIOSAsset.textWhite.color)
//        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.semiBold.font(size: 20))
//    }
//    
//    override func setupBind() {
//        super.setupBind()
//        
//        inviteButton.rx.tap
//            .bind { [weak self] _ in
//                let discussionInviteVC = PlannerInviteViewController()
//                
//                self?.navigationController?.pushViewController(discussionInviteVC, animated: true)
//            }
//            .disposed(by: disposeBag)
//    }
//    
//    func bind(reactor: Reactor) {
//        // Action
//        rx.viewWillAppear
//            .map { _ in .refresh }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//        
//        discussionCollectionView.rx.itemSelected
//            .map { .didTapDiscussionCollecionViewCell($0) }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
//        
//        // State
//        reactor.state.map(\.sections).asObservable()
//            .bind(to: discussionCollectionView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
//        
//        reactor.state.map(\.tagPresentJYPTagBottomSheet).asObservable()
//            .distinctUntilChanged()
//            .withUnretained(self)
//            .bind { this, tag in
//                guard let tag = tag else { return }
//                let jypTagBottomSheetVC = JYPTagBottomSheetViewController(reactor: .init(state: .init(tag: tag)))
//                
//                this.tabBarController?.present(jypTagBottomSheetVC, animated: true, completion: nil)
//            }
//            .disposed(by: disposeBag)
//        
//        reactor.state.map(\.candidatePlacePresentPlannerSearchPlaceWebViewController).asObservable()
//            .withUnretained(self)
//            .bind { this, candidatePlace in
//                guard let candidatePlace = candidatePlace else { return }
//                let webVC = WebViewController(reactor: WebReactor(state: .init(url: candidatePlace.url)))
//                
//                this.tabBarController?.present(webVC, animated: true, completion: nil)
//            }
//            .disposed(by: disposeBag)
//        
//        reactor.state.map(\.isPresentPlannerSearchPlaceViewController)
//            .asObservable()
//            .distinctUntilChanged()
//            .withUnretained(self)
//            .bind { this, bool in
//                if bool {
//                    let plannerSearchPlaceVC = PlannerSearchPlaceViewController(reactor: PlannerSearchPlaceReactor())
//                    
//                    this.navigationController?.pushViewController(plannerSearchPlaceVC, animated: true)
//                }
//            }
//            .disposed(by: disposeBag)
//    }
//}
//
//extension OldPlannerHomeViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 60)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return .init(top: 0, left: 24, bottom: 48, right: 24)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 8
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        switch dataSource[indexPath.section].items[indexPath.row] {
//        case .jypTagItem(let reactor):
//            return CGSize(width: reactor.currentState.text.size(withAttributes: [NSAttributedString.Key.font: JYPIOSFontFamily.Pretendard.medium.font(size: 16)]).width + 50, height: 32)
//        case .createCandidatePlaceItem:
//            return CGSize(width: collectionView.frame.width - 48, height: 224)
//        case .candidatePlaceItem:
//            return CGSize(width: collectionView.frame.width - 48, height: 165) 
//        }
//    }
//}