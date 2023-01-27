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

    /// view를 원형으로 만들 수 있는 함수
    func cornerRounds() {
        layer.cornerRadius = layer.frame.height / 2
        layer.masksToBounds = true
    }

    /// 특정  모서리에 round를 줄 수 있는 함수
    /// - Parameters:
    ///   - radius: radius 정도
    ///   - direct: 모서리 방향 (기본값으로 모든 모서리가 포함)
    func cornerRound(radius: CGFloat, direct: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]) {
        layer.cornerRadius = radius
        layer.maskedCorners = direct
        layer.masksToBounds = true
    }
    
    /// 특정  모서리에 round를 줄 수 있는 함수
    /// - Parameters:
    ///   - topLeft: 왼쪽 위 radius 정도
    ///   - topRight: 오른쪽 위 radius 정도
    ///   - bottomLeft: 왼쪽 아래 radius 정도
    ///   - bottomRight: 오른쪽 아래 radius 정도
    func cornerRound(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        let topLeftRadius = CGSize(width: topLeft, height: topLeft)
        let topRightRadius = CGSize(width: topRight, height: topRight)
        let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
        let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
        let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }

    /// 그림자 적용 함수
    /// - Parameters:
    ///   - radius: 퍼짐 정도
    ///   - offset: 그림자 위치값
    ///   - opacity: color Opacity 값
    ///   - color: 그림자 color
    func setShadow(radius: CGFloat, offset: CGSize, opacity: Float, color: UIColor = .black) {
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    /// Border 적용 함수
    /// - Parameters:
    ///   - color: UIColor 색상
    ///   - width: border 너비
    func makeBorder(color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
}
