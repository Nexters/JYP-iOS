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
    let inviteStackView: JYPInviteStackView = .init()
    let headerView: UIView = .init()
    let discussionButton: JYPBottomBorderButton = .init(title: "토론장")
    let journeyPlanButton: JYPBottomBorderButton = .init(title: "여행 계획")
    let menuDivider: UIView = .init()
    let discussionView: DiscussionView
    let journeyPlanView: JourneyPlanView
    
    // MARK: - Initializer
    
    init(reactor: Reactor) {
        discussionView = .init(reactor: .init(id: reactor.currentState.id))
        journeyPlanView = .init(reactor: .init(id: reactor.currentState.id))
        
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
        
        setNavigationBarBackButtonTintColor(.white)
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
        
        menuDivider.backgroundColor = .black.withAlphaComponent(0.1)
        
        inviteStackView.update(users: [.init(id: "", nickname: "", profileImagePath: "", personality: .FW), .init(id: "", nickname: "", profileImagePath: "", personality: .FW), .init(id: "", nickname: "", profileImagePath: "", personality: .FW), .init(id: "", nickname: "", profileImagePath: "", personality: .FW), .init(id: "", nickname: "", profileImagePath: "", personality: .FW)])
        inviteButton.isHidden = true
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([dateLabel, inviteButton, inviteStackView, headerView, discussionButton, journeyPlanButton, menuDivider, discussionView, journeyPlanView])
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
        
        inviteStackView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
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
        
        menuDivider.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.centerY.equalTo(journeyPlanButton.bottomBorderView.snp.centerY)
            make.height.equalTo(1)
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
        rx.viewWillAppear
            .map { _ in .refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        inviteButton.rx.tap
            .map { .invite }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        inviteStackView.inviteButton.rx.tap
            .map { .invite }
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
                this.discussionButton.isSelected = bool
                this.discussionView.isHidden = !bool
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isShowJourneyPlan)
            .withUnretained(self)
            .bind { this, bool in
                this.journeyPlanButton.isSelected = bool
                this.journeyPlanView.isHidden = !bool
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap(\.plannerInviteReactor)
            .withUnretained(self)
            .bind { this, reactor in
                let plannerInviteViewController = PlannerInviteViewController(reactor: reactor)
                
                plannerInviteViewController.hidesBottomBarWhenPushed = true
                this.navigationController?.pushViewController(plannerInviteViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap(\.tagBottomSheetReactor)
            .withUnretained(self)
            .bind { this, reactor in
                this.tabBarController?.present(TagBottomSheetViewController(reactor: reactor), animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap(\.plannerSearchPlaceReactor)
            .withUnretained(self)
            .bind { this, reactor in
                this.navigationController?.pushViewController(PlannerSearchPlaceViewController(reactor: reactor), animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap(\.plannerRouteReactor)
            .withUnretained(self)
            .bind { this, reactor in
                this.navigationController?.pushViewController(PlannerRouteViewController(reactor: reactor), animated: true)
            }
            .disposed(by: disposeBag)
         
        reactor.state
            .compactMap(\.webReactor)
            .withUnretained(self)
            .bind { this, reactor in
                this.navigationController?.present(WebViewController(reactor: reactor), animated: true)
            }
            .disposed(by: disposeBag)
    }
}
