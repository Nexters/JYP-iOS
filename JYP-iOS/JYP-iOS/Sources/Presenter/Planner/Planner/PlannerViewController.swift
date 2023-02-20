//
//  PlannerViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class PlannerViewController: NavigationBarViewController, View {
    typealias Reactor = PlannerReactor
    
    private let pushPlannerInviteScreen: (_ id: String) -> PlannerInviteViewController
    private let pushPlannerRouteScreen: (_ root: AnyObject.Type, _ journey: Journey, _ order: Int) -> PlannerRouteViewController
    private let pushTagBottomSheetScreen: () -> TagBottomSheetViewController
    private let pushPlannerSearchPlaceScreen: () -> PlannerSearchPlaceViewController
    private let pushWebScreen: (_ url: String) -> WebViewController
    private let pushJourneyPlanScreen: () -> JourneyPlanView
    private let pushDiscussionScreen: () -> DiscussionView
    
    private lazy var journeyPlanView: JourneyPlanView = pushJourneyPlanScreen()
    private lazy var discussionView: DiscussionView = pushDiscussionScreen()
    
    // MARK: - UI Components
    
    let dateLabel: UILabel = .init()
    let inviteButton: UIButton = .init()
    let inviteStackView: JYPInviteStackView = .init()
    let headerView: UIView = .init()
    let discussionButton: JYPBottomBorderButton = .init(title: "토론장")
    let journeyPlanButton: JYPBottomBorderButton = .init(title: "여행 계획")
    let menuDivider: UIView = .init()
    
    // MARK: - Initializer
    
    init(reactor: Reactor,
         pushPlannerInviteScreen: @escaping (_ id: String) -> PlannerInviteViewController,
         pushPlannerRouteScreen: @escaping (_ root: AnyObject.Type, _ journey: Journey, _ order: Int) -> PlannerRouteViewController,
         pushWebScreen: @escaping (_ url: String) -> WebViewController,
         pushJourneyPlanScreen: @escaping () -> JourneyPlanView,
         pushDiscussionScreen: @escaping () -> DiscussionView) {
        self.pushPlannerInviteScreen = pushPlannerInviteScreen
        self.pushPlannerRouteScreen = pushPlannerRouteScreen
        self.pushJourneyPlanScreen = pushJourneyPlanScreen
        self.pushDiscussionScreen = pushDiscussionScreen
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        setNavigationBarBackButtonTintColor(.white)
        setNavigationBarBackgroundColor(JYPIOSAsset.backgroundGrey300.color)
        setNavigationBarTitleTextColor(JYPIOSAsset.textWhite.color)
        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.semiBold.font(size: 20))
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        view.backgroundColor = JYPIOSAsset.backgroundGrey300.color
        
        dateLabel.text = ""
        dateLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        dateLabel.textColor = JYPIOSAsset.textWhite.color
        
        inviteButton.setTitle("일행 초대하기", for: .normal)
        inviteButton.setTitleColor(.white, for: .normal)
        inviteButton.titleLabel?.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
        inviteButton.backgroundColor = JYPIOSAsset.mainPink.color
        inviteButton.setImage(JYPIOSAsset.inviteFriend.image, for: .normal)
        inviteButton.cornerRound(radius: 10)
        
        headerView.backgroundColor = JYPIOSAsset.backgroundWhite100.color
        headerView.cornerRound(radius: 20, direct: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        menuDivider.backgroundColor = .black.withAlphaComponent(0.1)
           
        inviteButton.isHidden = true
        inviteStackView.isHidden = true
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([dateLabel, inviteButton, inviteStackView, headerView, discussionButton, journeyPlanButton, menuDivider, discussionView, journeyPlanView])
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
        
        inviteStackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(inviteButton.snp.bottom).offset(13)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        discussionButton.snp.makeConstraints {
            $0.top.equalTo(headerView).offset(28)
            $0.leading.equalToSuperview().inset(24)
        }
        
        journeyPlanButton.snp.makeConstraints {
            $0.top.equalTo(headerView).offset(28)
            $0.leading.equalTo(discussionButton.snp.trailing).offset(28)
        }
        
        menuDivider.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.centerY.equalTo(journeyPlanButton.bottomBorderView.snp.centerY)
            make.height.equalTo(1)
        }
        
        discussionView.snp.makeConstraints {
            $0.top.equalTo(menuDivider.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        journeyPlanView.snp.makeConstraints {
            $0.top.equalTo(menuDivider.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind Method
    
    func bind(reactor: Reactor) {
        rx.viewWillAppear
            .map { _ in .refresh(self) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(inviteButton.rx.tap, inviteStackView.inviteButton.rx.tap)
            .subscribe(onNext: { [weak self] _, _ in
                self?.willPushPlannerInviteViewController(id: reactor.initialState.id)
            })
            .disposed(by: disposeBag)
        
        journeyPlanButton.rx.tap
            .map { .showView(.journeyPlan) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        discussionButton.rx.tap
            .map { .showView(.discussion) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap(\.journey)
            .map {($0,
                   DateManager.doubleToDateString(format: "M월d일", double: $0.startDate),
                   DateManager.doubleToDateString(format: "M월d일", double: $0.endDate))}
            .subscribe(onNext: { [weak self] journey, start, end in
                self?.dateLabel.text = String(describing: start + " - " + end)
                self?.inviteStackView.update(users: journey.users)
                self?.inviteButton.isHidden = !journey.users.isEmpty
                self?.inviteStackView.isHidden = journey.users.isEmpty
                self?.setNavigationBarTitleText(journey.name)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.viewType)
            .subscribe(onNext: { [weak self] type in
                self?.journeyPlanButton.isSelected = (type == .journeyPlan)
                self?.journeyPlanView.isHidden = (type == .journeyPlan)
                self?.discussionButton.isSelected = (type == .journeyPlan)
                self?.discussionView.isHidden = (type == .journeyPlan)
            })
            .disposed(by: disposeBag)
        
        journeyPlanView.reactor?.state
            .map(\.sections)
    }
}

extension PlannerViewController {
    func willPushPlannerInviteViewController(id: String) {
        let viewController = pushPlannerInviteScreen(id)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func willPushPlannerRouteViewController(root: AnyObject.Type, journey: Journey, order: Int) {
        let viewController = pushPlannerRouteScreen(root, journey, order)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func willPushPlannerSearchViewController() {
        let viewController = pushPlannerSearchPlaceScreen()
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func willPresentWebViewController(url: String) {
        let viewController = pushWebScreen(url)
        navigationController?.present(viewController, animated: true)
    }
    
    func willPresentTagBottomSheetViewController() {
        let viewController = pushTagBottomSheetScreen()
        tabBarController?.present(viewController, animated: true)
    }
}
