//
//  OnboardingHowToNewPlaceViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class OnboardingHowToNewPlaceViewController: NavigationBarViewController, View {
    typealias Reactor = OnboardingHowToNewPlaceReactor
    
    // MARK: - UI Components
    
    let selfView = OnboardingHowToNewPlaceView()
    
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
    
    func bind(reactor: OnboardingHowToNewPlaceReactor) {
        bindActions(to: reactor)
        bindStates(from: reactor)
    }
    
    func presentOnboardingWhenJourneyPlanViewController(reactor: OnboardingWhenJourneyPlanReactor) {
        let onboardingWhenJourneyPlanViewController = OnboardingWhenJourneyPlanViewController()
        onboardingWhenJourneyPlanViewController.reactor = reactor
        navigationController?.pushViewController(onboardingWhenJourneyPlanViewController, animated: true)
    }
}

// MARK: - Setup Binding Actions

extension OnboardingHowToNewPlaceViewController {
    func bindActions(to reactor: OnboardingHowToNewPlaceReactor) {
        bindDidTapCardViewA(to: reactor)
        bindDidTapCardViewB(to: reactor)
        bindDidTapNextButton(to: reactor)
    }
    
    func bindDidTapCardViewA(to reactor: OnboardingHowToNewPlaceReactor) {
        selfView.onboardingCardViewA.rx.tapGesture()
            .filter { $0.state == .ended }
            .map { _ in .didTapCardViewA }
            .distinctUntilChanged()
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindDidTapCardViewB(to reactor: OnboardingHowToNewPlaceReactor) {
        selfView.onboardingCardViewB.rx.tapGesture()
            .filter { $0.state == .ended }
            .map { _ in .didTapCardViewB }
            .distinctUntilChanged()
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindDidTapNextButton(to reactor: OnboardingHowToNewPlaceReactor) {
        selfView.nextButton.rx.tap
            .map { .didTapNextButton }
            .distinctUntilChanged()
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup Binding States

extension OnboardingHowToNewPlaceViewController {
    func bindStates(from reactor: OnboardingHowToNewPlaceReactor) {
        bindStateCardViewA(from: reactor)
        bindStateCardViewB(from: reactor)
        bindIsActiveNextButton(from: reactor)
        bindIsPresentOnboardingWhenJourneyPlan(from: reactor)
    }
    
    func bindStateCardViewA(from reactor: OnboardingHowToNewPlaceReactor) {
        reactor.state
            .map { $0.stateCardViewA }
            .distinctUntilChanged()
            .bind { [weak self] state in
                self?.selfView.onboardingCardViewA.state = state
            }
            .disposed(by: disposeBag)
    }
    
    func bindStateCardViewB(from reactor: OnboardingHowToNewPlaceReactor) {
        reactor.state
            .map { $0.stateCardViewB }
            .distinctUntilChanged()
            .bind { [weak self] state in
                self?.selfView.onboardingCardViewB.state = state
            }
            .disposed(by: disposeBag)
    }
    
    func bindIsActiveNextButton(from reactor: OnboardingHowToNewPlaceReactor) {
        reactor.state
            .map { $0.isActiveNextButton }
            .distinctUntilChanged()
            .bind { [weak self] bool in
                self?.selfView.nextButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
    }
    
    func bindIsPresentOnboardingWhenJourneyPlan(from reactor: OnboardingHowToNewPlaceReactor) {
        reactor.state
            .map { $0.isPresentOnboardingWhenJourneyPlan }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in reactor.getOnboardingWhenJourneyPlanReactor() }
            .bind(onNext: presentOnboardingWhenJourneyPlanViewController)
            .disposed(by: disposeBag)
    }
}
