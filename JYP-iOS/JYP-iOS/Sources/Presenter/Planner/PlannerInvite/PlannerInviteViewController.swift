//
//  DiscusstionInviteViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/06.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class PlannerInviteViewController: NavigationBarViewController, View {
    typealias Reactor = PlannerInviteReactor
    
    // MARK: - UI Components
    
    let titleLabel: UILabel = .init()
    let subLabel: UILabel = .init()
    let linkInviteButton: JYPButton = .init(type: .linkInvite)
    
    // MARK: - Initializer
    
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.text = "일행을 초대해 주세요!"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 24)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.text = "일행은 최대 8명까지 초대할 수 있어요"
        subLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        subLabel.textColor = JYPIOSAsset.tagGrey200.color
        
        linkInviteButton.isEnabled = false
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([titleLabel, subLabel, linkInviteButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9)
            $0.leading.equalToSuperview().inset(24)
        }
        
        linkInviteButton.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
    }
    
    func bind(reactor: Reactor) { }
}
