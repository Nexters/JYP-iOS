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
    
    func bind(reactor: OnboardingQuestionReactor) {
        onboardingQuestionView.onboardingCardViewA.rx.tapGesture()
            .filter { $0.state == .ended }
            .map { _ in .tapFirstView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        onboardingQuestionView.onboardingCardViewB.rx.tapGesture()
            .filter { $0.state == .ended }
            .map { _ in .tapSecondView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        onboardingQuestionView.nextButton.rx.tap
            .map { .tapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.stateFirstView }
            .bind { [weak self] state in
                self?.onboardingQuestionView.onboardingCardViewA.state = state
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.stateSecondView }
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
        
        reactor.state
            .compactMap(\.onboardingQuestionReactor)
            .withUnretained(self)
            .bind { this, reactor in
                let onboardingQuestionPlaceViewController = OnboardingQuestionPlaceViewController(reactor: reactor)
                
                this.navigationController?.pushViewController(onboardingQuestionPlaceViewController, animated: true)
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
