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
    
    let scrollView: UIScrollView = .init()
    let titleLabel: UILabel = .init()
    let subLabel: UILabel = .init()
    let linkInviteButton: JYPButton = .init(type: .linkInvite)
    let divider: UIView = .init()
    
    let stepLabel: UILabel = .init()
    let oneStepView: InviteStepView = .init(type: .one)
    let twoStepView: InviteStepView = .init(type: .two)
    let threeStepView: InviteStepView = .init(type: .three)
    
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
        
        scrollView.backgroundColor = .white
        
        titleLabel.text = "일행을 초대해 주세요!"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 24)
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.text = "일행은 최대 8명까지 초대할 수 있어요"
        subLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        subLabel.textColor = JYPIOSAsset.tagGrey200.color
        
        linkInviteButton.isEnabled = true
        
        divider.backgroundColor = JYPIOSAsset.tagWhiteGrey100.color
        
        stepLabel.text = "일행과 여행을\n함께 계획하는 법"
        stepLabel.font = JYPIOSFontFamily.Pretendard.bold.font(size: 22)
        stepLabel.textColor = JYPIOSAsset.textB80.color
        stepLabel.numberOfLines = 0
        stepLabel.lineSpacing(lineHeight: 36)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubview(scrollView)
        
        scrollView.addSubviews([titleLabel, subLabel, linkInviteButton, divider, stepLabel, oneStepView, twoStepView, threeStepView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(view.bounds.width)
            $0.height.equalToSuperview()
        }
        
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
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(linkInviteButton.snp.bottom).offset(28)
            $0.width.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        stepLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(24)
        }
        
        oneStepView.snp.makeConstraints {
            $0.top.equalTo(stepLabel.snp.bottom).offset(28)
            $0.width.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        
        twoStepView.snp.makeConstraints {
            $0.top.equalTo(oneStepView.snp.bottom).offset(44)
            $0.width.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        
        threeStepView.snp.makeConstraints {
            $0.top.equalTo(twoStepView.snp.bottom).offset(44)
            $0.width.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        linkInviteButton.rx.tap
            .bind { [weak self] _ in
                UIPasteboard.general.string = reactor.id
                let vc = JYPToastMessageViewController(message: "클립보드에 복사되었습니다!")
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: false)
            }
            .disposed(by: disposeBag)
    }
}
