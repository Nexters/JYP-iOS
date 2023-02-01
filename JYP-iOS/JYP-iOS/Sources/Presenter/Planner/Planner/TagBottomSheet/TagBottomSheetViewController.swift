//
//  TagBottomSheetViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/07.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

class TagBottomSheetViewController: BottomSheetViewController, View {
    typealias Reactor = TagBottomSheetReactor
    
    // MARK: - UI Components
    
    let containerView: UIView = .init()
    let titleLabel: UILabel = .init()
    let okButton: UIButton = .init()
    let tag: JYPTag = .init()
    let scrollView: UIScrollView = .init()
    let stackView: UIStackView = .init()
    
    // MARK: - Initializer
    
    init(reactor: Reactor) {
        super.init(mode: .drag)
        
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addContentView(view: containerView)
    }
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
  
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 20)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        okButton.setTitle("확인", for: .normal)
        okButton.setTitleColor(JYPIOSAsset.textB40.color, for: .normal)
        okButton.titleLabel?.font = JYPIOSFontFamily.Pretendard.regular.font(size: 16)
        
        tag.isSelected = false
        
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        stackView.alignment = .leading
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        containerView.addSubviews([titleLabel, okButton, tag, scrollView])
        scrollView.addSubviews([stackView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.leading.equalToSuperview()
        }
        
        okButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(titleLabel)
        }
        
        tag.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(tag.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(23)
        }
        
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {        
        titleLabel.text = reactor.currentState.tag.orientation.title + " 태그"
        tag.type = reactor.currentState.tag.orientation
        tag.titleLabel.text = reactor.currentState.tag.topic
        
        reactor.currentState.tag.users.forEach {
            stackView.addArrangedSubview(ProfileBox(type: .tag, imagePath: $0.profileImagePath, title: $0.nickname))
        }
    }
}
