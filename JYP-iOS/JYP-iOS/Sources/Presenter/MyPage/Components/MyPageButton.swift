//
//  MyPageButton.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/20.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class MyPageButton: UIButton {
    let nameLabel: UILabel = .init()
    let accessoryLabel: UILabel = .init()

    // MARK: - Initializer

    init(title: String, info: String? = nil) {
        super.init(frame: .zero)

        nameLabel.text = title
        accessoryLabel.text = info ?? ""

        setupProperty()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupProperty() {
        cornerRound(radius: 10)
        backgroundColor = .white

        nameLabel.lineSpacing(lineHeight: 25.5)
        nameLabel.textColor = JYPIOSAsset.textB80.color

        accessoryLabel.lineSpacing(lineHeight: 24)
        accessoryLabel.textColor = JYPIOSAsset.textB40.color
    }

    func setupLayout() {
        addSubviews([nameLabel, accessoryLabel])

        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }

        accessoryLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        snp.makeConstraints { make in
            make.height.equalTo(72)
        }
    }
}
