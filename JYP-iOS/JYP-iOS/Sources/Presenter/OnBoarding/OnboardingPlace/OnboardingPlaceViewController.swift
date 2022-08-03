//
//  OnboardingPlaceViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/31.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class OnboardingPlaceViewController: NavigationBarViewController, View {
    typealias Reactor = OnboardingPlaceReactor
    
    // MARK: - UI Components
    
    let selfView = OnboardingPlaceView()
    
    // MARK: - Setup Methods
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        setNavigationBarHidden(true)
    }
    
    override func setupProperty() {
        super.setupProperty()
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubview(selfView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        selfView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: OnboardingPlaceReactor) {
        bindActions(to: reactor)
        bindStates(from: reactor)
    }
    
    func presentOnboardingSignUpViewController(reactor: OnboardingSignUpReactor) {
        let onboardingSignUpViewController = OnboardingSignUpViewController()
        onboardingSignUpViewController.reactor = reactor
        navigationController?.pushViewController(onboardingSignUpViewController, animated: true)
    }
}

// MARK: - Setup Binding Actions

extension OnboardingPlaceViewController {
    func bindActions(to reactor: OnboardingPlaceReactor) {
        bindDidTapNextButton(to: reactor)
    }
    
    func bindDidTapNextButton(to reactor: OnboardingPlaceReactor) {
        selfView.nextButton.rx.tap
            .map { .didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup Binding States

extension OnboardingPlaceViewController {
    func bindStates(from reactor: OnboardingPlaceReactor) {
        bindIsPresentOnboardingPlace(from: reactor)
    }
    
    func bindIsPresentOnboardingPlace(from reactor: OnboardingPlaceReactor) {
        reactor.state
            .map { $0.isPresentOnboardingSignUp }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in reactor.getOnboardingSignUpReactor() }
            .bind(onNext: presentOnboardingSignUpViewController)
            .disposed(by: disposeBag)
    }
}
