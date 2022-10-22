//
//  JYPTagProfileStackView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/07.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

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
        
        setupProperty()
    }
    
    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addArrangedSubview(_ view: UIView) {
        super.addArrangedSubview(view)
        
        sendSubviewToBack(view)
    }
    
    // MARK: - Setup Methods
    
    func update(users: [User]) {
        profiles = users
    }
    
    func setupProperty() {
        spacing = -16.0
        axis = .horizontal
        distribution = .fillEqually
    }
    
    func setupLayout() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        profiles.enumerated().forEach { index, user in
            if index == 0 {
                addArrangedSubview(JYPProfileView(image: JYPIOSAsset.iconInvite.image))
            } else {
                addArrangedSubview(JYPProfileView(user: user))
            }
        }
    }
}

// MARK: - JYPProfileView

class JYPProfileView: BaseView {
    // MARK: - UI Components
    
    let imageView: UIImageView = .init()
    
    // MARK: - Setup Methods
    
    init(user: User) {
        super.init(frame: .zero)
        
        // TODO: 실제 이미지 주소 변경
//        imageView.kf.setImage(with: URL(string: user.profileImagePath))
        imageView.image = JYPIOSAsset.profile1.image
    }
    
    init(image: UIImage) {
        super.init(frame: .zero)
        
        imageView.image = image
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()

        imageView.cornerRound(radius: 12)
        imageView.makeBorder(color: JYPIOSAsset.backgroundGrey300.color, width: 2.18)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([imageView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        snp.makeConstraints {
            $0.size.equalTo(44)
        }
    }
}
