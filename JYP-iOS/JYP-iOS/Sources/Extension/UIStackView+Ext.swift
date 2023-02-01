//
//  UIStackView+Ext.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/01/29.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }

    func removeArrangedSubviews() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}
