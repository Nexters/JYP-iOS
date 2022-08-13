//
//  DiscussionTagBottomSheetViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

class JYPTagBottomSheetViewController: BottomSheetViewController, View {
    typealias Reactor = JYPTagBottomSheetReactor
    
    let bottomSheetView = UIView()
    let titleLabel = UILabel()
    let tag = JYPTag()
    let imageStackView = UIStackView()
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(reactor: Reactor) {
        super.init(mode: .drag)
        
        self.reactor = reactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addContentView(view: bottomSheetView)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        for _ in 0...3 {
            let imageBox = ImageBox(image: JYPIOSAsset.iconCulturePlace.image, title: "이소")
            
            imageStackView.addArrangedSubview(imageBox)
        }
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 20)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        tag.isSelected = false
        
        imageStackView.distribution = .equalSpacing
        imageStackView.spacing = 12
        imageStackView.alignment = .leading
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        bottomSheetView.addSubviews([titleLabel, tag, imageStackView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.leading.equalToSuperview()
        }
        
        tag.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview()
        }
        
        imageStackView.snp.makeConstraints {
            $0.top.equalTo(tag.snp.bottom).offset(12)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview().inset(23)
        }
    }
    
    func bind(reactor: JYPTagBottomSheetReactor) {
        let state = reactor.currentState
        
        titleLabel.text = state.tag.type.title + " 태그"
        tag.type = state.tag.type
        tag.titleLabel.text = state.tag.text
    }
}
