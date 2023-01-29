//
//  CreateProfileBottomSheetViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/01/29.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import Foundation

import UIKit
import ReactorKit
import RxSwift

class CreateProfileBottomSheetViewController: BottomSheetViewController, View {
    typealias Reactor = CreateProfileBottomSheetReactor
    
    // MARK: - UI Components
    
    let containerView: UIView = .init()
    let titleLabel: UILabel = .init()
    let button: UIButton = .init()
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
        
        button.setTitle("확인", for: .normal)
        button.setTitleColor(JYPIOSAsset.textB40.color, for: .normal)
        button.titleLabel?.font = JYPIOSFontFamily.Pretendard.regular.font(size: 16)
        
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        stackView.alignment = .leading
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        containerView.addSubviews([titleLabel, button, stackView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.leading.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(titleLabel)
        }
        
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.height.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        Observable.zip(
            reactor.state.compactMap(\.nickname).asObservable(),
            reactor.state.compactMap(\.personalityID).asObservable()
        )
        .map { String(describing: "\($0)님은\n\($1.title)이시군요!") }
        .bind(to: titleLabel.rx.text)
        .disposed(by: disposeBag)
    }
}
