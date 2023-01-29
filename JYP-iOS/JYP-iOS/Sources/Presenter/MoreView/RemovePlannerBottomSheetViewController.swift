//
//  RemovePlannerBottomSheetViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2023/01/29.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import UIKit

final class RemovePlannerBottomSheetViewController: BottomSheetViewController {
    private let containerView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 20)
        label.textColor = JYPIOSAsset.textB80.color
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = JYPIOSFontFamily.Pretendard.regular.font(size: 16)
        label.textColor = JYPIOSAsset.textB75.color
        label.text = "나간 플래너는 다시 확인할 수 없어요"
        return label
    }()

    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 12
        view.distribution = .fillEqually
        [noButton, yesButton].forEach { view.addArrangedSubview($0) }
        return view
    }()

    private let noButton: JYPButton = {
        let button = JYPButton(type: .no)
        button.isEnabled = false
        return button
    }()

    private let yesButton = JYPButton(type: .yes)

    init() {
        super.init(mode: .drag)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        containerView.addSubviews([titleLabel, subTitleLabel, buttonStackView])
        addContentView(view: containerView)
    }

    override func setupLayout() {
        super.setupLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(subTitleLabel.snp.bottom).offset(67)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
            make.bottom.equalToSuperview()
        }
    }
}
