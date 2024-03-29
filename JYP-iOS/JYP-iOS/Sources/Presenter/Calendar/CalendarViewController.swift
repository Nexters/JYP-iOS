//
//  CalendarViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

class CalendarViewController: BottomSheetViewController, View {
    typealias Reactor = CalendarReactor

    // MARK: - UI Components

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: .zero)
        picker.preferredDatePickerStyle = .inline
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "ko-KR")
        picker.timeZone = .autoupdatingCurrent
        return picker
    }()

    // MARK: - Initializer

    init(reactor: CalendarReactor) {
        super.init(mode: .fixed)

        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    override func setupLayout() {
        super.setupLayout()

        addContentView(view: datePicker)
        datePicker.snp.makeConstraints { make in
            make.height.equalTo(380)
        }
    }

    func bind(reactor: CalendarReactor) {
        datePicker.rx.date
            .skip(1)
            .map { Reactor.Action.selectDateAction($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .compactMap(\.startDate)
            .bind(to: datePicker.rx.minimumDate)
            .disposed(by: disposeBag)

        reactor.state.asObservable()
            .map(\.isDismissed)
            .filter { $0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        reactor.state
            .map(\.selectedDate)
            .bind(to: datePicker.rx.date)
            .disposed(by: disposeBag)
    }
}
