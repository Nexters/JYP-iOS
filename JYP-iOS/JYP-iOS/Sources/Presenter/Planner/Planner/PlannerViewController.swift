//
//  PlannerViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class PlannerViewController: NavigationBarViewController, View {
    typealias Reactor = PlannerReactor
    
    // MARK: - UI Components
    
    let dateLabel: UILabel = .init()
    let inviteButton: UIButton = .init()
    
    let headerView: UIView = .init()
    
    let discussionButton: UIButton = .init()
    let journeyPlanButton: UIButton = .init()
    
    let menuDivider: UIView = .init()
    
    lazy var discussionView: DiscussionView = .init(reactor: DiscussionReactor())
    let journeyPlanView: JourneyPlanView = .init()
    
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
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        setNavigationBarBackgroundColor(JYPIOSAsset.backgroundGrey300.color)
        setNavigationBarTitleText("강릉 여행기")
        setNavigationBarTitleTextColor(JYPIOSAsset.textWhite.color)
        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.semiBold.font(size: 20))
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        view.backgroundColor = JYPIOSAsset.backgroundGrey300.color
        
        dateLabel.text = "7월 18일 - 7월 20일"
        dateLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        dateLabel.textColor = JYPIOSAsset.textWhite.color
        
        inviteButton.setTitle("일행 초대하기", for: .normal)
        inviteButton.setTitleColor(.white, for: .normal)
        inviteButton.titleLabel?.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
        inviteButton.backgroundColor = JYPIOSAsset.mainPink.color
        inviteButton.setImage(JYPIOSAsset.inviteFriend.image, for: .normal)
        inviteButton.cornerRound(radius: 10)
        
        headerView.backgroundColor = JYPIOSAsset.backgroundWhite100.color
        headerView.cornerRound(radius: 20, direct: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        discussionButton.setTitle("토론장", for: .normal)
        discussionButton.setTitleColor(JYPIOSAsset.textB80.color, for: .normal)
        discussionButton.titleLabel?.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 18)
        
        journeyPlanButton.setTitle("여행 계획", for: .normal)
        journeyPlanButton.setTitleColor(JYPIOSAsset.textB80.color, for: .normal)
        journeyPlanButton.titleLabel?.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 18)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([dateLabel, inviteButton, headerView, discussionButton, journeyPlanButton, menuDivider, discussionView, journeyPlanView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        
        inviteButton.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(133)
            $0.height.equalTo(40)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(inviteButton.snp.bottom).offset(13)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        discussionButton.snp.makeConstraints {
            $0.top.equalTo(headerView).offset(28)
            $0.leading.equalToSuperview().inset(24)
        }
        
        journeyPlanButton.snp.makeConstraints {
            $0.top.equalTo(headerView).offset(28)
            $0.leading.equalTo(discussionButton.snp.trailing).offset(28)
        }
        
        menuDivider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalTo(discussionButton.snp.bottom)
            $0.height.equalTo(1)
        }
        
        discussionView.snp.makeConstraints {
            $0.top.equalTo(menuDivider.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        journeyPlanView.snp.makeConstraints {
            $0.top.equalTo(menuDivider.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind Method
    
    func bind(reactor: Reactor) {
        // Action
        
        rx.viewWillAppear
            .map { _ in .refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        discussionButton.rx.tap
            .map { .showDiscussion }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        journeyPlanButton.rx.tap
            .map { .showJourneyPlan }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        
        reactor.state
            .map(\.isShowDiscussion)
            .withUnretained(self)
            .bind { this, bool in
                this.discussionView.isHidden = !bool
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isShowJourneyPlan)
            .withUnretained(self)
            .bind { this, bool in
                this.journeyPlanView.isHidden = !bool
            }
            .disposed(by: disposeBag)
    }
}