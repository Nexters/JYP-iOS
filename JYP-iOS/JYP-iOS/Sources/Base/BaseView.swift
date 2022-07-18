//
//  BaseView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/17.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/*
    BaseViewController
    - setupProperty()
        - 프로퍼티 관련 - label.font, ...
    - setupHierarchy()
        - 계층 관련 - addSubView, ...
    - setupLayout()
        - 레이아웃 관련 - view.snp.makeConstraints, ...
    - setupBind()
        - 바인딩 관련 - button.rx.tap.bind, ...
*/

protocol BaseViewProtocol {
    func setupProperty()
    func setupHierarchy()
    func setupLayout()
    func setupBind()
}

class BaseView: UIView, BaseViewProtocol {
    let disposeBag = DisposeBag()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupProperty()
        setupHierarchy()
        setupLayout()
        setupBind()
    }
    
    func setupProperty() { }
    
    func setupHierarchy() { }
    
    func setupLayout() { }
    
    func setupBind() { }
}
