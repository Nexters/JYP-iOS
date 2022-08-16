//
//  UILabel+Ext.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/17.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

extension UILabel {
    func lineSpacing(lineHeight: CGFloat) {
        if let text = self.text {
            let spacing = lineHeight - font.pointSize
            
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()

            style.lineSpacing = spacing

            attributeString.addAttribute(.paragraphStyle, value: style, range: .init(location: 0, length: attributeString.length))
            attributedText = attributeString
        }
    }
}
