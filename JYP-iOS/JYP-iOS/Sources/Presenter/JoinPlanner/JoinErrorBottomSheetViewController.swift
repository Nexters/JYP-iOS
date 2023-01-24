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
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = JYPIOSFontFamily.Pretendard.regular.font(size: 16)
        label.textColor = JYPIOSAsset.textB75.color
        label.numberOfLines = 0
        return label
    }()

    private var confirmButton: JYPButton!

    init(error: JYPNetworkError) {
        super.init(mode: .drag)
        configureError(error: error)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
            make.leading.trailing.equalToSuperview()
        }

        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(72).priority(.low)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(52)
        }
    }

    private func bind() {
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func configureError(error: JYPNetworkError) {
        titleLabel.text = error.errorDescription
        subTitleLabel.text = error.associatedValue

        switch error {
        case .exceededUser, .notExistJourney:
            confirmButton = .init(type: .nextTime)
        default:
            confirmButton = .init(type: .confirm)
        }
    }
}
