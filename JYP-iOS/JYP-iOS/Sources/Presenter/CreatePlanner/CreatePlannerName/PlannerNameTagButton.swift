//
//  PlannerNameTagButton.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/09/03.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class PlannerNameTagButton: UIButton {
    // MARK: - UI Components

    private let nameLabel = UILabel()

    // MARK: - Property

    var name: PlannerNameTag

    // MARK: - Initializer

    init(name: PlannerNameTag) {
        self.name = name
        super.init(frame: .zero)

        setupProperty()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        cornerRound(radius: 8)
    }

    // MARK: - Setup Methods

    func setupLayout() {
        addSubview(nameLabel)

        nameLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }

    func setupProperty() {
        nameLabel.text = name.rawValue
        nameLabel.textColor = JYPIOSAsset.subBlue300.color
        nameLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)

        backgroundColor = JYPIOSAsset.tagWhiteBlue100.color
    }
}
