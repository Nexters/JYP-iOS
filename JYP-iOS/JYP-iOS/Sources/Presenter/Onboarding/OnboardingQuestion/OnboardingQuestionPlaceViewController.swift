//
//  OnboardingHowToNewPlaceViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class OnboardingQuestionPlaceViewController: NavigationBarViewController, View {
    // MARK: - Properties
    
    typealias Reactor = OnboardingQuestionReactor
    
    private let pushOnboardingQuestionPlanScreen: () -> OnboardingQuestionPlanViewController
    
    // MARK: - UI Components
    
    let onboardingQuestionView = OnboardingQuestionView(type: .place)
    
    // MARK: - Initializer
    
    init(reactor: OnboardingQuestionReactor,
         pushOnboardingQuestionPlanScreen: @escaping () -> OnboardingQuestionPlanViewController) {
        self.pushOnboardingQuestionPlanScreen = pushOnboardingQuestionPlanScreen
        
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
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
        onboardingQuestionView.firstView.rx.tapGesture()
            .when(.recognized)
            .filter { $0.state == .ended }
            .map { _ in .tapFirstView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        onboardingQuestionView.secondView.rx.tapGesture()
            .when(.recognized)
            .filter { $0.state == .ended }
            .map { _ in .tapSecondView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        onboardingQuestionView.nextButton.rx.tap
            .withUnretained(self)
            .bind { this, action in
                if let isActive = this.reactor?.currentState.isActive {
                    if isActive {
                        this.reactor?.action.onNext(.tapNextButton)
                        this.willPushOnboardingQuestionPlanViewController()
                    }
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.stateFirstView }
            .bind { [weak self] state in
                self?.onboardingQuestionView.firstView.state = state
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.stateSecondView }
            .bind { [weak self] state in
                self?.onboardingQuestionView.secondView.state = state
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isActive }
            .bind { [weak self] bool in
                self?.onboardingQuestionView.nextButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
    }
}

extension OnboardingQuestionPlaceViewController {
    func willPushOnboardingQuestionPlanViewController() {
        let viewController = pushOnboardingQuestionPlanScreen()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
