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
    // MARK: - Sub Type
    
    enum ProfileBoxType {
        case create
        case tag
        
        var cornerRadius: Double {
            switch self {
            case .create:
                return 20.0
            case .tag:
                return 12.0
            }
        }
    }
    
    // MARK: - Properties
    
    var isSelected: Bool = false {
        didSet {
            if isSelected {
                checkImageView.isHidden = false
            } else {
                checkImageView.isHidden = true
            }
        }
    }
    
    let type: ProfileBoxType
    
    // MARK: - UI Components
    
    let imageView: UIImageView = .init()
    let checkImageView: UIImageView = .init(image: JYPIOSAsset.iconCheck.image)
    let titleLabel: UILabel = .init()
    
    // MARK: - Initializer
    
    init(type: ProfileBoxType, imagePath: String? = nil, title: String? = nil) {
        self.type = type
        super.init(frame: .zero)
        
        if let imagePath = imagePath {
            update(imagePath: imagePath, title: title)
        }
    }
    
    func update(imagePath: String, title: String?) {
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
        
        imageView.cornerRound(radius: type.cornerRadius)
        
        titleLabel.textAlignment = .center
        
        checkImageView.isHidden = true
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([imageView, titleLabel, checkImageView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        if type == .create {
            imageView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(70)
            }
        } else {
            imageView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(44)
            }
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(60)
            $0.bottom.equalToSuperview()
        }
        
        checkImageView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.top).offset(-11)
            $0.trailing.equalTo(imageView.snp.trailing).offset(10)
            $0.width.height.equalTo(40)
        }
    }
}
