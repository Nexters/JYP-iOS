//
//  JYPSearchTextField.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/06.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

enum JYPSearchTextFieldType {
    case place
    case region
    case tag
    case planner
    
    var config: JYPSeachTextFieldConfig {
        switch self {
        case .place:
            return .init(placeholderText: "예) 서울 저니 식당", font: JYPIOSFontFamily.Pretendard.semiBold.font(size: 18), textColor: JYPIOSAsset.textB90.color, backgroundColor: JYPIOSAsset.backgroundWhite200.color)
        case .region:
            return .init(placeholderText: "도, 시를 입력해주세요.", font: JYPIOSFontFamily.Pretendard.semiBold.font(size: 24), textColor: JYPIOSAsset.textB90.color, backgroundColor: JYPIOSAsset.backgroundWhite200.color)
        case .tag:
            return .init(placeholderText: "입력해주세요", font: JYPIOSFontFamily.Pretendard.semiBold.font(size: 24), textColor: JYPIOSAsset.textB90.color, backgroundColor: JYPIOSAsset.backgroundWhite100.color)
        case .planner:
            return .init(placeholderText: "예) 제주도 여행기", font: JYPIOSFontFamily.Pretendard.semiBold.font(size: 24), textColor: JYPIOSAsset.textB90.color, backgroundColor: JYPIOSAsset.backgroundWhite100.color)
        }
    }
    
    var trailingIcon: UIImage {
        switch self {
        case .place, .region:
            return JYPIOSAsset.iconSearch.image
        case .tag, .planner:
            return UIImage()
        }
    }
    
    var isHiddenBottomBorder: Bool {
        switch self {
        case .place, .region: return true
        case .tag, .planner: return false
        }
    }
}

struct JYPSeachTextFieldConfig {
    let placeholderText: String
    let font: UIFont
    let textColor: UIColor
    let backgroundColor: UIColor
}

class JYPSearchTextField: BaseView {
    let type: JYPSearchTextFieldType
    let textField = UITextField()
    let trailingButton = UIButton()
    let bottomBorderLine = UIView()
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(type: JYPSearchTextFieldType) {
        self.type = type
        
        super.init(frame: .zero)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        backgroundColor = type.config.backgroundColor
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.tintColor = JYPIOSAsset.textB90.color
        textField.placeholder = type.config.placeholderText
        textField.font = type.config.font
        textField.textColor = type.config.textColor
        
        trailingButton.setImage(type.trailingIcon, for: .normal)
        trailingButton.setImage(JYPIOSAsset.iconTextDelete.image, for: .selected)
        
        bottomBorderLine.backgroundColor = .black.withAlphaComponent(0.1)
        bottomBorderLine.isHidden = type.isHiddenBottomBorder
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([textField, trailingButton, bottomBorderLine])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        textField.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalTo(trailingButton.snp.leading).offset(-6)
        }
        
        trailingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        bottomBorderLine.snp.makeConstraints { make in
            make.bottom.equalTo(textField.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
        textField.rx.text.orEmpty
            .withUnretained(self)
            .bind { this, text in
                if text.isEmpty {
                    this.trailingButton.isSelected = false
                } else {
                    this.trailingButton.isSelected = true
                }
            }
            .disposed(by: disposeBag)
        
        trailingButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                if this.trailingButton.isSelected {
                    this.textField.text = ""
                    this.trailingButton.isSelected = false
                }
            }
            .disposed(by: disposeBag)
    }
}
