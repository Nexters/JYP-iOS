//
//  NavigationBar.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/26.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import UIKit

class NavigationBar: BaseView {
    
    let contentView: UIView
    let backButton = UIButton(type: .system)
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(contentView: UIView) {
        self.contentView = contentView
        
        super.init(frame: .zero)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        backButton.setTitle("뒤로 가기 버튼(임시)", for: .normal)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([backButton, contentView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(backButton.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
}
