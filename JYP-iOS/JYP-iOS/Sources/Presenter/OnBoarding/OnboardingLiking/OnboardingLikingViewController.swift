//
//  OnboardingLikingViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/31.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class OnboardingLikingViewController: NavigationBarViewController, View {
    typealias Reactor = OnboardingLikingReactor
    
    // MARK: - UI Components
    
    var selfView = OnboardingLikingView()
     
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
    
    override func setupBind() {
        super.setupBind()
    }
    
    func bind(reactor: OnboardingLikingReactor) {
        bindActions(to: reactor)
        bindStates(from: reactor)
    }
    
    func presentOnboardingLikingViewController(at reactor: OnboardingPlaceReactor) {
        let onboardingPlaceViewController = OnboardingPlaceViewController()
        onboardingPlaceViewController.reactor = reactor
        navigationController?.pushViewController(onboardingPlaceViewController, animated: true)
    }
}

// MARK: - Setup Binding Actions

extension OnboardingLikingViewController {
    func bindActions(to reactor: OnboardingLikingReactor) {
        bindDidTapNextButton(to: reactor)
    }
    
    func bindDidTapNextButton(to reactor: OnboardingLikingReactor) {
        selfView.nextButton.rx.tap
            .map { .didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup Binding States

extension OnboardingLikingViewController {
    func bindStates(from reactor: OnboardingLikingReactor) {
        bindIsPresentOnboardingPlace(from: reactor)
    }
    
    func bindIsPresentOnboardingPlace(from reactor: OnboardingLikingReactor) {
        reactor.state
            .map { $0.isPresentOnboardingPlace }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in reactor.getOnboardingPlaceReactor() }
            .bind(onNext: presentOnboardingLikingViewController)
            .disposed(by: disposeBag)
    }
}
