//
//  ProfileBoxView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/10/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileBox: BaseView {
    // MARK: - UI Components
    
    let imageView: UIImageView = .init()
    let titleLabel: UILabel = .init()
    
    // MARK: - Initializer
    
    init(imagePath: String, title: String) {
        super.init(frame: .zero)
        
        imageView.kf.setImage(with: URL(string: imagePath))
        
        titleLabel.text = title
        titleLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        imageView.cornerRound(radius: 12)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([imageView, titleLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(60)
            $0.bottom.equalToSuperview()
        }
    }
}
