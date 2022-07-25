//
//  UIVIew+Ext.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/25.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}
