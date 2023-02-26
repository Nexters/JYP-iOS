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
    private let pushPlannerRouteScreen: (_ index: Int, _ journey: Journey) -> PlannerRouteViewController
    private let pushTagBottomSheetScreen: (_ tag: Tag) -> TagBottomSheetViewController
    private let pushPlannerSearchPlaceScreen: (_ id: String) -> PlannerSearchPlaceViewController
    private let pushWebScreen: (_ url: String) -> WebViewController
    
    private let journeyPlanView: JourneyPlanView
    private let discussionView: DiscussionView
    
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
         pushPlannerRouteScreen: @escaping (_ index: Int, _ journey: Journey) -> PlannerRouteViewController,
         pushTagBottomSheetScreen: @escaping (_ tag: Tag) -> TagBottomSheetViewController,
         pushPlannerSearchPlaceScreen: @escaping (_ id: String) -> PlannerSearchPlaceViewController,
         pushWebScreen: @escaping (_ url: String) -> WebViewController) {
        self.pushPlannerInviteScreen = pushPlannerInviteScreen
        self.pushPlannerRouteScreen = pushPlannerRouteScreen
        self.pushTagBottomSheetScreen = pushTagBottomSheetScreen
        self.pushPlannerSearchPlaceScreen = pushPlannerSearchPlaceScreen
        self.pushWebScreen = pushWebScreen
        
        self.discussionView = DiscussionView(reactor: .init())
        self.journeyPlanView = JourneyPlanView(reactor: .init())
        
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
            .map { _ in .refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        inviteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.willPushPlannerInviteViewController(id: reactor.initialState.id)
            })
            .disposed(by: disposeBag)
        
        inviteStackView.inviteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.willPushPlannerInviteViewController(id: reactor.initialState.id)
            })
            .disposed(by: disposeBag)
        
        discussionButton.rx.tap
            .map { .showView(.discussion) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        journeyPlanButton.rx.tap
            .map { .showView(.journeyPlan) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        discussionView.reactor?.action
            .subscribe(onNext: { action in
                reactor.bind(action: action)
            })
            .disposed(by: discussionView.disposeBag)
        
        journeyPlanView.reactor?.action
            .subscribe(onNext: { action in
                reactor.bind(action: action)
            })
            .disposed(by: journeyPlanView.disposeBag)
        
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
                
                self?.discussionView.reactor?.bind(action: .refresh(journey))
                self?.journeyPlanView.reactor?.bind(action: .refresh(journey))
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.viewType)
            .subscribe(onNext: { [weak self] type in
                self?.journeyPlanButton.isSelected = (type == .journeyPlan)
                self?.journeyPlanView.isHidden = !(type == .journeyPlan)
                self?.discussionButton.isSelected = (type == .discussion)
                self?.discussionView.isHidden = !(type == .discussion)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap(\.nextScreenType)
            .subscribe(onNext: { [weak self] type in
                switch type {
                case let .tagBottomSheet(tag):
                    self?.willPresentTagBottomSheetViewController(tag: tag)
                case let .plannerSearchPlace(id):
                    self?.willPushPlannerSearchPlaceViewController(id: id)
                case let .plannerRoute(index, journey):
                    self?.willPushPlannerRouteViewController(index: index, journey: journey)
                case let .web(url):
                    self?.willPresentWebViewController(url: url)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension PlannerViewController {
    func willPushPlannerInviteViewController(id: String) {
        let viewController = pushPlannerInviteScreen(id)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func willPushPlannerRouteViewController(index: Int, journey: Journey) {
        let viewController = pushPlannerRouteScreen(index, journey)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func willPushPlannerSearchPlaceViewController(id: String) {
        let viewController = pushPlannerSearchPlaceScreen(id)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func willPresentWebViewController(url: String) {
        let viewController = pushWebScreen(url)
        navigationController?.present(viewController, animated: true)
    }
    
    func willPresentTagBottomSheetViewController(tag: Tag) {
        let viewController = pushTagBottomSheetScreen(tag)
        tabBarController?.present(viewController, animated: true)
    }
}
