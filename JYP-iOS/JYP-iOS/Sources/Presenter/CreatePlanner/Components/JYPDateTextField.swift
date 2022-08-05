//
//  JYPDateTextField.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/01.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class JYPDateTextField: UITextField {
    // MARK: - Properties

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                textColor = JYPIOSAsset.textB90.color
            } else {
                textColor = JYPIOSAsset.textB40.color
            }
        }
    }

    // MARK: - Initializer

    override init(frame _: CGRect) {
        super.init(frame: .zero)
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

    func setupUI() {
        makeBorder(color: JYPIOSAsset.subBlue300.color, width: 1.0)
    }
}
