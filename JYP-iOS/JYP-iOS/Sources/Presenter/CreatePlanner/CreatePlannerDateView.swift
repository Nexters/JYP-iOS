//
//  CreatePlannerDateView.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/06.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class CreatePlannerDateView: BaseView {
    // MARK: - UI Components

    var titleLabel: UILabel = .init()
    var subTitleLabel: UILabel = .init()

    var startDateLabel: UILabel = .init()
    var endDateLabel: UILabel = .init()

    var startDateTextField: JYPDateTextField = .init()
    var endDateTextField: JYPDateTextField = .init()
    var dividerLabel: UILabel = .init()

    var journeyDaysButton: UIButton = .init()

    var submitButton: JYPButton = .init(type: .done)

    init() {
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupProperty() {
        super.setupProperty()

        titleLabel.text = "언제 출발하시나요?"
        titleLabel.textColor = JYPIOSAsset.textB90.color
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 24)

        subTitleLabel.text = "시작 일을 알려주세요"
        subTitleLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 16)
        subTitleLabel.textColor = JYPIOSAsset.textB40.color

        startDateLabel.text = "여행 시작"
        startDateLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        startDateLabel.textColor = JYPIOSAsset.textB80.color

        endDateLabel.text = "여행 종료"
        endDateLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        endDateLabel.textColor = JYPIOSAsset.textB80.color

        startDateTextField.inputView = UIView()
        startDateTextField.tintColor = .clear

        endDateTextField.inputView = UIView()
        endDateTextField.tintColor = .clear

        dividerLabel.text = "-"
        dividerLabel.textColor = JYPIOSAsset.textB90.color
        dividerLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 22)

        journeyDaysButton.backgroundColor = JYPIOSAsset.tagWhiteBlue100.color
        journeyDaysButton.setTitleColor(JYPIOSAsset.subBlue300.color, for: .normal)
        journeyDaysButton.cornerRound(radius: 20)

        submitButton.setTitle("선택하기", for: .normal)
        submitButton.backgroundColor = .systemPink
        submitButton.titleLabel?.textColor = .white
        submitButton.isHidden = true
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        addSubviews([titleLabel, subTitleLabel, startDateLabel, endDateLabel, startDateTextField, dividerLabel, endDateTextField, journeyDaysButton, submitButton])
    }

    override func setupLayout() {
        super.setupLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
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
            make.width.equalTo(150)
            make.height.equalTo(46)
        }

        dividerLabel.snp.makeConstraints { make in
            make.leading.equalTo(startDateTextField.snp.trailing).offset(9)
            make.centerY.equalTo(startDateTextField.snp.centerY)
        }

        endDateTextField.snp.makeConstraints { make in
            make.leading.equalTo(dividerLabel.snp.trailing).offset(8)
            make.centerY.equalTo(startDateTextField.snp.centerY)
            make.width.equalTo(150)
            make.height.equalTo(46)
        }

        journeyDaysButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(106)
            make.bottom.equalTo(submitButton.snp.top).offset(-18)
            make.height.equalTo(44)
        }

        submitButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(24)
            make.height.equalTo(52)
        }
    }
}
