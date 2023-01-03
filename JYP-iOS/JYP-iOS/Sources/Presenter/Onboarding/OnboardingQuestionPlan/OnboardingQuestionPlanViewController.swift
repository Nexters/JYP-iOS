//
//  OnboardingWhenJourneyPlanViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class OnboardingQuestionPlanViewController: NavigationBarViewController, View {
    typealias Reactor = OnboardingQuestionReactor
    
    // MARK: - UI Components
    
    let onboardingQuestionView = OnboardingQuestionView(type: .plan)
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(reactor: OnboardingQuestionReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubview(onboardingQuestionView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        onboardingQuestionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func bind(reactor: OnboardingQuestionReactor) {
        onboardingQuestionView.onboardingCardViewA.rx.tapGesture()
            .filter { $0.state == .ended }
            .map { _ in .didTapCardViewA }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        onboardingQuestionView.onboardingCardViewB.rx.tapGesture()
            .filter { $0.state == .ended }
            .map { _ in .didTapCardViewB }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        onboardingQuestionView.nextButton.rx.tap
            .map { .didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.stateCardViewA }
            .bind { [weak self] state in
                self?.onboardingQuestionView.onboardingCardViewA.state = state
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.stateCardViewB }
            .bind { [weak self] state in
                self?.onboardingQuestionView.onboardingCardViewB.state = state
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isActiveNextButton }
            .bind { [weak self] bool in
                self?.onboardingQuestionView.nextButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
        
//        reactor.state
//            .compactMap(\.myPlannerReactor)
//            .withUnretained(self)
//            .bind { this, reactor in
//                let myPlannerViewController = MyPlannerViewController(reactor: reactor, p)
//
//                this.navigationController?.pushViewController(myPlannerViewController, animated: true)
//            }
//            .disposed(by: disposeBag)
    }
}
