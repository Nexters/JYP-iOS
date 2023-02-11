//
//  LogoutBottomSheetViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/02/11.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import Foundation

import UIKit
import ReactorKit
import RxSwift

class LogoutBottomSheetViewController: BottomSheetViewController, View {
    typealias Reactor = LogoutBottomSheetReactor
    
    // MARK: - UI Components
    
    let containerView: UIView = .init()
    let titleLabel: UILabel = .init()
    let subLabel: UILabel = .init()
    
    let stackView: UIStackView = .init()
    let noButton: JYPButton = .init(type: .no)
    let yesButton: JYPButton = .init(type: .yes)
    
    // MARK: - Initializer
    
    init(reactor: Reactor) {
        super.init(mode: .fixed)
        
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
        
        titleLabel.text = "로그아웃 하시나요?"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 20)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.text = "다시 돌아올 때까지 기다릴게요!"
        subLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 16)
        subLabel.textColor = JYPIOSAsset.textB40.color
        
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.alignment = .leading
        
        [noButton, yesButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(52)
            }
        }
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        containerView.addSubviews([titleLabel, subLabel, stackView])
        stackView.addArrangedSubviews([noButton, yesButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.leading.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(72)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(6)
        }
    }
    
    func bind(reactor: Reactor) {
        noButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        yesButton.rx.tap
            .map { .tapLogoutButton }
            .subscribe(reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.dismiss)
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
