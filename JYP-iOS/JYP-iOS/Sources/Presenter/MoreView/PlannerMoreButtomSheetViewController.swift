//
//  PlannerMoreButtomSheetViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2023/01/29.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import UIKit

final class PlannerMoreButtomSheetViewController: BottomSheetViewController {
    private let containerView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 20)
        label.textColor = JYPIOSAsset.textB80.color
        return label
    }()

    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(JYPIOSAsset.textB40.color, for: .normal)
        button.titleLabel?.font = JYPIOSFontFamily.Pretendard.regular.font(size: 18)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()

    private let deleteButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .left
        button.setImage(JYPIOSAsset.iconDelete.image, for: .normal)
        button.setTitle("나가기", for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        button.setTitleColor(JYPIOSAsset.textB75.color, for: .normal)
        button.imageEdgeInsets.right = -16
        button.titleEdgeInsets.left = 16
        return button
    }()

    private let journey: Journey

    init(journey: Journey) {
        self.journey = journey
        super.init(mode: .drag)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func setupProperty() {
        super.setupProperty()

        titleLabel.text = journey.name
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        containerView.addSubviews([titleLabel, cancelButton, deleteButton])
        addContentView(view: containerView)
    }

    override func setupLayout() {
        super.setupLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.trailing.equalTo(cancelButton.snp.leading).offset(-5)
        }

        cancelButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel)
        }

        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(24)
        }
    }

    private func bind() {
        deleteButton.rx.tap
            .subscribe { _ in
                guard let presentingViewController = self.presentingViewController
                else { return }

                self.dismiss(animated: true) {
                    presentingViewController.present(RemovePlannerBottomSheetViewController(), animated: true)
                }
            }
    }
}
