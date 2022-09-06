//
//  JYPTagProfileStackView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/07.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

// MARK: - JYPProfileStackView

class JYPProfileStackView: UIStackView {

    // MARK: - UI Components
    
    let imageView: UIImageView = .init()
    
    // MARK: - Properties
    
    var profiles: [User] = [] {
        didSet {
            setupLayout()
        }
    }
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    func setupProperty() {
        spacing = 12.0
        axis = .horizontal
        distribution = .fillProportionally
    }
    
    func setupLayout() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        profiles.forEach { user in
            addArrangedSubview(JYPProfileView(user: user))
        }
    }
}

// MARK: - JYPProfileView

class JYPProfileView: BaseView {

    // MARK: - UI Components
    
    let imageView: UIImageView = .init()
    let label: UILabel = .init()
    
    // MARK: - Setup Methods
    
    init(user: User) {
        super.init(frame: .zero)
        
        imageView.kf.setImage(with: URL(string: user.profileImagePath))
        label.text = user.nickname
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        label.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
        label.textColor = JYPIOSAsset.textB75.color
        label.textAlignment = .center
        
        imageView.cornerRound(radius: 12)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(50)
        }
    }
}
