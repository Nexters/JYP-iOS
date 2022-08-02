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

    private var titleLabel: UILabel = .init()
    private var subTitleLabel: UILabel = .init()

    private var startDateLabel: UILabel = .init()
    private var endDateLabel: UILabel = .init()

    private var startDateTextField: UITextField = .init()
    private var endDateTextField: UITextField = .init()

    private var submitButton: UIButton = .init()

    // MARK: - Properties

    let dateFormatter = DateFormatter().then {
        $0.dateFormat = "yy.MM.dd"
        $0.locale = Locale(identifier: "ko_KR")
    }

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

    override func setupProperty() {
        super.setupProperty()

        titleLabel.text = "언제 출발하시나요?"
        titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)

        subTitleLabel.text = "시작 일을 알려주세요"
        subTitleLabel.font = .systemFont(ofSize: 16, weight: .regular)
        subTitleLabel.textColor = .gray

        startDateLabel.text = "여행 시작"
        startDateLabel.font = .systemFont(ofSize: 12, weight: .regular)

        endDateLabel.text = "여행 종료"
        endDateLabel.font = .systemFont(ofSize: 12, weight: .regular)

        startDateTextField.borderStyle = .line
        startDateTextField.inputView = UIView()
        startDateTextField.tintColor = .clear

        endDateTextField.borderStyle = .line
        endDateTextField.inputView = UIView()
        endDateTextField.tintColor = .clear

        submitButton.setTitle("선택하기", for: .normal)
        submitButton.backgroundColor = .systemPink
        submitButton.titleLabel?.textColor = .white
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
        rx.viewDidLoad
            .map { _ in Reactor.Action.startDateAction }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        startDateTextField.rx.tapGesture()
            .map { _ in Reactor.Action.startDateAction }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        endDateTextField.rx.tapGesture()
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
            .map(\.startDate)
            .distinctUntilChanged()
            .map { [weak self] in self?.dateFormatter.string(from: $0)
            }
            .bind(to: startDateTextField.rx.text)
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
