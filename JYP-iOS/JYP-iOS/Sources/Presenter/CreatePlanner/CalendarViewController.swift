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

    private var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupProperty() {
        super.setupProperty()

        datePicker = .init().then {
            $0.preferredDatePickerStyle = .inline
            $0.datePickerMode = .date
            $0.locale = Locale(identifier: "ko-KR")
            $0.timeZone = .autoupdatingCurrent
        }

        reactor = .init()
    }

    override func setupLayout() {
        super.setupLayout()

        datePicker.snp.makeConstraints { make in
            make.height.equalTo(300)
        }

        addContentView(view: datePicker)
    }

    func bind(reactor: CalendarReactor) {
        datePicker.rx.date
            .skip(1)
            .map { Reactor.Action.selectDateAction($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state.asObservable()
            .map(\.isDismissed)
            .filter { $0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.dismiss(animated: true, completion: {
                    /// 여기서 날짜 전달
                })
            }
            .disposed(by: disposeBag)
    }
}
