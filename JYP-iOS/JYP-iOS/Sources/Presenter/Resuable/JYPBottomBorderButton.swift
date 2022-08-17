//
//  JYPBottomBorderButton.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/14.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class JYPBottomBorderButton: UIButton {
    // MARK: - UI Components

    let headerLabel: UILabel = .init()
    let bottomBorderView: UIView = .init()

    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            if isSelected {
                headerLabel.textColor = JYPIOSAsset.textB80.color
                bottomBorderView.backgroundColor = JYPIOSAsset.textB80.color
            } else {
                headerLabel.textColor = JYPIOSAsset.textB40.color
                bottomBorderView.backgroundColor = .clear
            }
        }
    }

    // MARK: - Initializer

    init(title: String) {
        headerLabel.text = title

        super.init(frame: .zero)

        setupProperty()
        setupHierarchy()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bottomBorderView.cornerRounds()
    }

    // MARK: - Setup Methods

    func setupProperty() {
        headerLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 18)
        headerLabel.textColor = JYPIOSAsset.textB80.color

        bottomBorderView.backgroundColor = JYPIOSAsset.textB80.color

        isSelected = false
    }

    func setupHierarchy() {
        addSubviews([headerLabel, bottomBorderView])
    }

    func setupLayout() {
        headerLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        bottomBorderView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(2.6)
        }
    }
}
