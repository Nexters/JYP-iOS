//
//  CalendarViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class CalendarViewController: BottomSheetViewController {
    // MARK: - UI Components

    private var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupProperty() {
        super.setupProperty()

        datePicker = .init().then {
            $0.preferredDatePickerStyle = .inline
        }
    }

    override func setupLayout() {
        super.setupLayout()

        datePicker.snp.makeConstraints { make in
            make.height.equalTo(300)
        }

        addContentView(view: datePicker)
    }
}
