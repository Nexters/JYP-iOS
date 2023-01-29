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
    // MARK: - Properties
    
    typealias Reactor = OnboardingQuestionReactor
    
    private let pushTabBarScreen: (() -> TabBarViewController)?
    
    // MARK: - UI Components
    
    let onboardingQuestionView = OnboardingQuestionView(type: .plan)
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(reactor: OnboardingQuestionReactor,
         pushTabBarScreen: @escaping () -> TabBarViewController) {
        self.pushTabBarScreen = pushTabBarScreen
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
        onboardingQuestionView.firstView.rx.tapGesture()
            .filter { $0.state == .ended }
            .map { _ in .tapFirstView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        onboardingQuestionView.secondView.rx.tapGesture()
            .filter { $0.state == .ended }
            .map { _ in .tapSecondView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        onboardingQuestionView.nextButton.rx.tap
            .map { .tapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        onboardingQuestionView.nextButton.rx.tap
            .filter { reactor.currentState.isActive }
            .bind { [weak self] _ in
                self?.willPresentTabBarViewController()
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

extension OnboardingQuestionPlanViewController {
    private func willPresentTabBarViewController() {
        if let viewController = pushTabBarScreen?() {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
