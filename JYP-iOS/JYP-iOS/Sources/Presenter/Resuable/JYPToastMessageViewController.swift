//
//  JYPToastMessageViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/11/27.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class JYPToastMessageViewController: BaseViewController {    
    let messageView: UIView = .init()
    let messageLabel: UILabel = .init()
    
    init(message: String) {
        super.init(nibName: nil, bundle: nil)
        
        messageLabel.text = message
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            self?.dismiss(animated: false)
        }
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        view.backgroundColor = .clear
        
        messageView.backgroundColor = .white
        messageView.cornerRound(radius: 27)
        messageView.setShadow(radius: 40, offset: .init(width: 4, height: 10), opacity: 0.06)
        
        messageLabel.font = JYPIOSFontFamily.Pretendard.bold.font(size: 14)
        messageLabel.textColor = JYPIOSAsset.textB80.color
        messageLabel.textAlignment = .center
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubview(messageView)
        messageView.addSubview(messageLabel)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        messageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(3)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(55)
            $0.height.equalTo(50)
        }
        
        messageLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
    }
}
