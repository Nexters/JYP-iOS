//
//  JYPButton.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

struct JYPButtonConfig {
    let inactive: JYPButtonConfigElement
    let active: JYPButtonConfigElement?
}

struct JYPButtonConfigElement {
    let title: String?
    let titleColor: UIColor?
    let backgroundColor: UIColor?
}

class JYPButton: UIButton {
    let config: JYPButtonConfig
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(config: JYPButtonConfig) {
        self.config = config
        
        super.init(frame: .zero)
        
        setTitle(config.inactive.title, for: .normal)
        setTitleColor(config.inactive.titleColor, for: .normal)
        setTitle(config.active?.title, for: .selected)
        setTitleColor(config.active?.titleColor, for: .selected)
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? config.inactive.backgroundColor : config.active?.backgroundColor
        }
    }
}
