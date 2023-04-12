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
    
    func asFont(targetString: String, font: UIFont) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(.font, value: font, range: range)
        attributedText = attributedString
    }
    
    func asColor(targetString: String, color: UIColor) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedText = attributedString
    }
    
    func asFontColor(targetString: String, font: UIFont?, color: UIColor?) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttributes([.font: font as Any, .foregroundColor: color as Any], range: range)
        attributedText = attributedString
    }
    
    func asFontColor(targetStringList: [String], font: UIFont?, color: UIColor?, height: CGFloat? = nil) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)

        targetStringList.forEach {
            let range = (fullText as NSString).range(of: $0)
            attributedString.addAttributes([.font: font as Any, .foregroundColor: color as Any], range: range)
        }
        
        if let height = height, let font = self.font {
            let spacing = height - font.pointSize
            let style = NSMutableParagraphStyle()

            style.lineSpacing = spacing
            attributedString.addAttribute(.paragraphStyle, value: style, range: .init(location: 0, length: attributedString.length))
        }
          
        attributedText = attributedString
    }
}
