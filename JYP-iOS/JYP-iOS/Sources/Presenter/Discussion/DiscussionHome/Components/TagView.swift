//
//  TagView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/07.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class TagView: BaseView {
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(image: UIImage, title: String) {
        super.init(frame: .zero)
        
        imageView.image = image
        titleLabel.text = title
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        backgroundColor = JYPIOSAsset.tagWhiteBlue100.color
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        titleLabel.textColor = JYPIOSAsset.subBlue300.color
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([imageView, titleLabel])
    }
}
