//
//  CreatePlannerDateViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/28.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

class CreatePlannerDateViewController: BaseViewController, View {
    typealias Reactor = CreatePlannerDateReactor

    // MARK: - UI Components

    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!

    private var startDateLabel: UILabel!
    private var endDateLabel: UILabel!

    private var startDateTextField: UITextField!
    private var endDateTextField: UITextField!

    private var submitButton: UIButton!

    // MARK: - Setup Methods

    override func setupProperty() {
        super.setupProperty()

        titleLabel = .init().then {
            $0.text = "언제 출발하시나요?"
            $0.font = .systemFont(ofSize: 24, weight: .semibold)
        }

        subTitleLabel = .init().then {
            $0.text = "시작 일을 알려주세요"
            $0.font = .systemFont(ofSize: 16, weight: .regular)
            $0.textColor = .gray
        }

        startDateLabel = .init().then {
            $0.text = "여행 시작"
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }

        endDateLabel = .init().then {
            $0.text = "여행 종료"
            $0.font = .systemFont(ofSize: 12, weight: .regular)
        }

        startDateTextField = .init().then {
            $0.borderStyle = .line
            $0.inputView = UIView()
        }

        endDateTextField = .init().then {
            $0.borderStyle = .line
            $0.inputView = UIView()
        }

        submitButton = .init().then {
            $0.setTitle("선택하기", for: .normal)
            $0.backgroundColor = .systemPink
            $0.titleLabel?.textColor = .white
        }

        reactor = .init(service: CalendarService())
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        view.addSubviews([titleLabel, subTitleLabel, startDateLabel, endDateLabel, startDateTextField, endDateTextField, submitButton])
    }

    override func setupLayout() {
        super.setupLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(74)
            make.leading.equalToSuperview().offset(24)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
        }

        startDateLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(46)
            make.leading.equalTo(subTitleLabel.snp.leading)
        }

        endDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(endDateTextField.snp.leading)
            make.centerY.equalTo(startDateLabel.snp.centerY)
        }

        startDateTextField.snp.makeConstraints { make in
            make.top.equalTo(startDateLabel.snp.bottom).offset(12)
            make.leading.equalTo(startDateLabel.snp.leading)
            make.width.equalTo(120)
            make.height.equalTo(42)
        }

        endDateTextField.snp.makeConstraints { make in
            make.leading.equalTo(startDateTextField.snp.trailing).offset(22)
            make.centerY.equalTo(startDateTextField.snp.centerY)
            make.width.equalTo(120)
            make.height.equalTo(42)
        }

        submitButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
            make.height.equalTo(52)
        }
    }

    func bind(reactor: CreatePlannerDateReactor) {
        startDateTextField.rx.controlEvent(.editingDidBegin)
            .map { _ in Reactor.Action.startDateAction }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        endDateTextField.rx.controlEvent(.editingDidBegin)
            .map { _ in Reactor.Action.endDateAction }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.asObservable()
            .filter(\.isFocusStartTextField)
            .subscribe(onNext: { [weak self] _ in
                let calendarViewController = CalendarViewController()
                calendarViewController.reactor = reactor.makeCalendarReactor()

                self?.tabBarController?.present(calendarViewController, animated: true)
            })
            .disposed(by: disposeBag)

        reactor.state
            .compactMap { $0.startDate }
            .distinctUntilChanged()
            .map { $0.description }
            .bind(to: startDateLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.asObservable()
            .filter(\.isFocusEndTextField)
            .subscribe(onNext: { [weak self] _ in
                let calendarViewController = CalendarViewController()

                self?.tabBarController?.present(calendarViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
