//
//  CreatePlannerDateViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/28.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

class CreatePlannerDateViewController: NavigationBarViewController, View {
    typealias Reactor = CreatePlannerDateReactor

    // MARK: - UI Components

    private let selfView = CreatePlannerDateView()

    // MARK: - Initializer

    init(reactor: CreatePlannerDateReactor) {
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

        setNavigationBarTitleText("여행 날짜")
        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.medium.font(size: 16))
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        contentView.addSubview(selfView)
    }

    override func setupLayout() {
        super.setupLayout()

        selfView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    func bind(reactor: CreatePlannerDateReactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.didTapStartDateTextField }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        selfView.startDateTextField.rx.tapGesture()
            .when(.recognized)
            .map { _ in Reactor.Action.didTapStartDateTextField }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        selfView.endDateTextField.rx.tapGesture()
            .when(.recognized)
            .map { _ in Reactor.Action.didTapEndDateTextField }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        selfView.submitButton.rx.tap
            .map { _ in Reactor.Action.didTapSubmitButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.asObservable()
            .map(\.isFocusStartTextField)
            .bind(to: selfView.startDateTextField.rx.isSelected)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isFocusStartTextField)
            .distinctUntilChanged()
            .filter { $0 == false }
            .map { _ in Reactor.Action.didTapEndDateTextField }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.asObservable()
            .map(\.isFocusEndTextField)
            .bind(to: selfView.endDateTextField.rx.isSelected)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.startDate)
            .distinctUntilChanged()
            .bind(to: selfView.startDateTextField.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.endDate)
            .distinctUntilChanged()
            .bind(to: selfView.endDateTextField.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isCompleted)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isCompleted in
                self?.selfView.startDateTextField.isCompleted = isCompleted
                self?.selfView.endDateTextField.isCompleted = isCompleted
            })
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journeyDays)
            .bind(to: selfView.journeyDaysButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isHiddenJourneyDaysButton)
            .bind(to: selfView.journeyDaysButton.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isHiddenSubmitButton)
            .bind(to: selfView.submitButton.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isPresent)
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                let calendarViewController = CalendarViewController(reactor: reactor.makeCalendarReactor())

                self?.present(calendarViewController, animated: true)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isPushCreateTagView)
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                let createTag = CreatePlannerTagViewController(reactor: reactor.makeCreateTagReactor())

                self?.navigationController?.pushViewController(createTag, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
