//
//  ImageBox.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class ImageBox: BaseView {
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
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([imageView, titleLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
