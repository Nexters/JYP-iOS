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

    // MARK: - UI Components

    let headerView: UIView = .init()
    let titleLabel: UILabel = .init()

    let scheduledJourneyButton: JYPBottomBorderButton = .init(title: "준비된 여행")
    let pastJourneyButton: JYPBottomBorderButton = .init(title: "지난 여행기")

    let addButton: UIButton = .init()

    let menuDivider: UIView = .init()

    lazy var scheduledJourneyView: ScheduledJourneyView = .init(reactor: ScheduledJourneyReactor())
    lazy var pastJourneyView: UIView = .init()

    // MARK: - Initializer

    init(reactor: Reactor) {
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
        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.medium.font(size: 16))
        setNavigationBarBackgroundColor(JYPIOSAsset.backgroundWhite200.color)
        setNavigationBarBackButtonHidden(true)
    }

    override func setupProperty() {
        super.setupProperty()

        headerView.backgroundColor = JYPIOSAsset.backgroundWhite200.color

        titleLabel.text = "자유로운 탐험가,\n다정님의 시작된 여행"
        titleLabel.numberOfLines = 0
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 22)
        titleLabel.lineSpacing(lineHeight: 34.1)
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
            make.size.equalTo(20)
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
        scheduledJourneyButton.rx.tap
            .map { .didTapScheduledJourneyMenu }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        pastJourneyButton.rx.tap
            .map { .didTapPastJourneyMenu }
            .bind(to: reactor.action)
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
    }
}
