//
//  OnboardingSignUpViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class OnboardingSignUpViewController: NavigationBarViewController, View {
    typealias Reactor = OnboardingSignUpReactor
    
    // MARK: - UI Components
    
    let selfView = OnboardingSignUpView()
    
    // MARK: - Setup Methods
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        setNavigationBarBackgroundColor(JYPIOSAsset.mainPink.color)
        setNavigationBarBackButtonHidden(true)
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
    
    func bind(reactor: OnboardingSignUpReactor) {
        bindActions(to: reactor)
        bindStates(from: reactor)
    }
}

// MARK: - Setup Binding Actions

extension OnboardingSignUpViewController {
    func bindActions(to reactor: OnboardingSignUpReactor) {
//        bindDidTapNextButton(to: reactor)
    }
    
    func bindDidTapNextButton(to reactor: OnboardingSignUpReactor) {
//        selfView.nextButton.rx.tap
//            .map { .didTapNextButton }
//            .bind(to: reactor.action)
//            .disposed(by: disposeBag)
    }
}

// MARK: - Setup Binding States

extension OnboardingSignUpViewController {
    func bindStates(from reactor: OnboardingSignUpReactor) {
//        bindIsPresentOnboardingPlace(from: reactor)
    }
    
    func bindIsPresentOnboardingPlace(from reactor: OnboardingSignUpReactor) {
//        reactor.state
//            .map { $0.isPresentOnboardingSignUp }
//            .distinctUntilChanged()
//            .filter { $0 }
//            .map { _ in reactor.getOnboardingSignUpReactor() }
//            .bind(onNext: presentOnboardingSignUpViewController)
//            .disposed(by: disposeBag)
    }
}
