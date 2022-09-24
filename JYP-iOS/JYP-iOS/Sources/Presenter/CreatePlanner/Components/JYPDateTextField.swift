//
//  JYPDateTextField.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/01.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

final class JYPDateTextField: UITextField {
    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .clear
                textColor = JYPIOSAsset.textB90.color

                makeBorder(color: JYPIOSAsset.subBlue300.color, width: 1.0)
            } else {
                backgroundColor = JYPIOSAsset.backgroundWhite200.color
                textColor = JYPIOSAsset.textB40.color

                makeBorder(color: .clear, width: 0.0)
            }
        }
    }

    final var isCompleted: Bool = false {
        didSet {
            textColor = JYPIOSAsset.textB90.color
            isEnabled = true

            makeBorder(color: .clear, width: 0.0)
        }
    }

    // MARK: - Initializer

    override init(frame _: CGRect) {
        super.init(frame: .zero)

        setupProperty()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        cornerRound(radius: 8.0)
    }

    // MARK: - Setup

    func setupProperty() {
        textAlignment = .center
        font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 20)
    }
}
