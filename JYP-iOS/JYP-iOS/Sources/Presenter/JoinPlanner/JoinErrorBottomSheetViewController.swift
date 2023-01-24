//
//  JoinErrorBottomSheetViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2023/01/21.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import UIKit

final class JoinErrorBottomSheetViewController: BottomSheetViewController {
    private let containerView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 20)
        label.textColor = JYPIOSAsset.textB80.color
        label.text = "잘못된 참여코드에요!"
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = JYPIOSFontFamily.Pretendard.regular.font(size: 16)
        label.textColor = JYPIOSAsset.textB75.color
        label.text = "정확한 코드를 다시 입력해주세요."
        return label
    }()

    private let confirmButton = JYPButton(type: .confirm)

    override func viewDidLoad() {
        bind()
        super.viewDidLoad()
    }

    override func setupHierarchy() {
        super.setupHierarchy()
        containerView.addSubviews([titleLabel, subTitleLabel, confirmButton])
        addContentView(view: containerView)
    }

    override func setupLayout() {
        super.setupLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
        }

        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(72).priority(.low)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(52)
        }
    }

    func bind() {
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
