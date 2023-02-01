//
//  OnboardingWhatIsTripViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class OnboardingQuestionJourneyViewController: NavigationBarViewController, View {
    // MARK: - Properties
    
    typealias Reactor = OnboardingQuestionReactor
    
    private let pushOnboardingQuestionPlaceScreen: () -> OnboardingQuestionPlaceViewController
    
    // MARK: - UI Components
    
    let onboardingQuestionView = OnboardingQuestionView(type: .journey)
    
    // MARK: - Setup Methods
    
    init(reactor: OnboardingQuestionReactor,
         pushOnboardingQuestionPlaceScreen: @escaping () -> OnboardingQuestionPlaceViewController) {
        self.pushOnboardingQuestionPlaceScreen = pushOnboardingQuestionPlaceScreen
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
        
        setNavigationBarBackButtonHidden(true)
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
    
    func bind(reactor: Reactor) {
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
            .filter { reactor.currentState.isActive }
            .bind { [weak self] _ in
                self?.willPushOnboardingQuestionPlaceViewController()
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

extension OnboardingQuestionJourneyViewController {
    func willPushOnboardingQuestionPlaceViewController() {
        let viewController = pushOnboardingQuestionPlaceScreen()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
