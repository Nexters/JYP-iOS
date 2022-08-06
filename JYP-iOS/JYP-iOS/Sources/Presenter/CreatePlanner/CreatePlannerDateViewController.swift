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
            $0.edges.equalToSuperview()
        }
    }

    func bind(reactor: CreatePlannerDateReactor) {
        rx.viewDidLoad
            .map { _ in Reactor.Action.didTapStartDateTextField }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        selfView.startDateTextField.rx.tapGesture()
            .map { _ in Reactor.Action.didTapStartDateTextField }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        selfView.endDateTextField.rx.tapGesture()
            .map { _ in Reactor.Action.didTapEndDateTextField }
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
            .map(\.isHiddenSubmitButton)
            .bind(to: selfView.submitButton.rx.isHidden)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isPresent)
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                let calendarViewController = CalendarViewController(reactor: reactor.makeCalendarReactor())

                self?.tabBarController?.present(calendarViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
