//
//  MyPlannerViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/17.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

class MyPlannerViewController: NavigationBarViewController, View {
    typealias Reactor = MyPlannerReactor
    
    private let pushSelectionPlannerJoinBottomScreen: () -> SelectionPlannerJoinBottomViewController
    private let pushPlannerScreen: (_ id: String) -> PlannerViewController
    private let presentPlannerMoreScreen: (_ journey: Journey) -> PlannerMoreButtomSheetViewController

    // MARK: - UI Components

    let headerView: UIView = .init()
    let titleLabel: UILabel = .init()

    let scheduledJourneyButton: JYPBottomBorderButton = .init(title: "준비된 여행")
    let pastJourneyButton: JYPBottomBorderButton = .init(title: "지난 여행기")

    let addButton: UIButton = .init()

    let menuDivider: UIView = .init()

    lazy var scheduledJourneyView: ScheduledJourneyView = .init(
        reactor: ScheduledJourneyReactor(parent: self),
        pushPlannerScreen: pushPlannerScreen,
        pushSelectionPlannerJoinBottomScreen: pushSelectionPlannerJoinBottomScreen,
        presentPlannerMoreScreen: presentPlannerMoreScreen
    )
    lazy var pastJourneyView: PastJourneyView = .init(
        reactor: PastJourneyReactor(parent: self),
        pushPlannerScreen: pushPlannerScreen,
        presentPlannerMoreScreen: presentPlannerMoreScreen
    )

    // MARK: - Initializer

    init(reactor: Reactor,
         pushSelectionPlannerJoinBottomScreen: @escaping () -> SelectionPlannerJoinBottomViewController,
         pushPlannerScreen: @escaping (_ id: String) -> PlannerViewController,
         presentPlannerMoreScreen: @escaping (_ journey: Journey) -> PlannerMoreButtomSheetViewController
    ) {
        self.pushSelectionPlannerJoinBottomScreen = pushSelectionPlannerJoinBottomScreen
        self.pushPlannerScreen = pushPlannerScreen
        self.presentPlannerMoreScreen = presentPlannerMoreScreen
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

        setNavigationBarTitleText("나의 여행")
        setNavigationBarTitleTextColor(JYPIOSAsset.textB75.color)
        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.medium.font(size: 16))
        setNavigationBarBackgroundColor(JYPIOSAsset.backgroundWhite200.color)
        setNavigationBarBackButtonHidden(true)
    }

    override func setupProperty() {
        super.setupProperty()

        headerView.backgroundColor = JYPIOSAsset.backgroundWhite200.color
        
        titleLabel.numberOfLines = 0
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 22)
        titleLabel.lineSpacing(lineHeight: 29)
        titleLabel.textColor = JYPIOSAsset.textB90.color

        scheduledJourneyButton.isSelected = true

        addButton.setImage(JYPIOSAsset.iconAdd.image, for: .normal)

        menuDivider.backgroundColor = .black.withAlphaComponent(0.1)
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        contentView.addSubviews([
            headerView, titleLabel, scheduledJourneyButton, pastJourneyButton, addButton, menuDivider,
            scheduledJourneyView, pastJourneyView
        ])
    }

    override func setupLayout() {
        super.setupLayout()

        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.bottom).offset(40)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.equalToSuperview().inset(24)
        }

        scheduledJourneyButton.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(24)
        }

        pastJourneyButton.snp.makeConstraints { make in
            make.centerY.equalTo(scheduledJourneyButton.snp.centerY)
            make.leading.equalTo(scheduledJourneyButton.snp.trailing).offset(28)
        }

        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(menuDivider.snp.top).offset(-7)
            make.size.equalTo(24)
        }

        menuDivider.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.centerY.equalTo(scheduledJourneyButton.bottomBorderView.snp.centerY)
            make.height.equalTo(1)
        }

        scheduledJourneyView.snp.makeConstraints { make in
            make.top.equalTo(menuDivider.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }

        pastJourneyView.snp.makeConstraints { make in
            make.top.equalTo(menuDivider.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Bind Method

    func bind(reactor: MyPlannerReactor) {
        rx.viewWillAppear
            .bind { [weak self] _ in
                self?.titleLabel.text = String(describing: "\(PersonalityID.toSelf(title: UserDefaultsAccess.get(key: .personality) ?? "").title),\n\(UserDefaultsAccess.get(key: .nickname) ?? "")님의 시작된 여행")
                self?.titleLabel.lineSpacing(lineHeight: 29)
                reactor.action.onNext(.fetchJourneyList)
            }
            .disposed(by: disposeBag)

        scheduledJourneyButton.rx.tap
            .map { .didTapScheduledJourneyMenu }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        pastJourneyButton.rx.tap
            .map { .didTapPastJourneyMenu }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        addButton.rx.tap
            .map { .didTapAddPlannerButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap(\.user)
            .map { String(describing: "\($0.personality.title),\n\($0.nickname)님의 시작된 여행") }
            .bind { [weak self] title in
                self?.titleLabel.text = title
                self?.titleLabel.lineSpacing(lineHeight: 29)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { !$0.isSelectedSchduledJourneyView }
            .distinctUntilChanged()
            .bind(to: scheduledJourneyView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isSelectedSchduledJourneyView)
            .distinctUntilChanged()
            .bind(to: scheduledJourneyButton.rx.isSelected)
            .disposed(by: disposeBag)

        reactor.state
            .map { !$0.isSelectedPastJourneyView }
            .distinctUntilChanged()
            .bind(to: pastJourneyView.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isSelectedPastJourneyView)
            .distinctUntilChanged()
            .bind(to: pastJourneyButton.rx.isSelected)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isPushCreatePlannerView)
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.willPushSelectionPlannerJoinBottomViewController()
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap(\.didCreatedPlannerID)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] id in
                self?.willPushPlannerViewController(id: id)
            })
            .disposed(by: disposeBag)
    }
}

extension MyPlannerViewController {
    func willPushSelectionPlannerJoinBottomViewController() {
        let viewController = pushSelectionPlannerJoinBottomScreen()

        self.tabBarController?.present(viewController, animated: true)
    }
    
    func willPushPlannerViewController(id: String) {
        let viewController = pushPlannerScreen(id)
        
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
