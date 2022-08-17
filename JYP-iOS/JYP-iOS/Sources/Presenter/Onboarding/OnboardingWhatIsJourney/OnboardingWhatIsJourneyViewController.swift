//
//  OnboardingWhatIsTripViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class OnboardingWhatIsJourneyViewController: NavigationBarViewController, View {
    typealias Reactor = OnboardingWhatIsJourneyReactor
    
    // MARK: - UI Components
    
    let selfView = OnboardingQuestionView(type: .whatIsJourney)
    
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
    
    func bind(reactor: OnboardingWhatIsJourneyReactor) {
        bindActions(to: reactor)
        bindStates(from: reactor)
    }
    
    func presentOnboardingHowToNewPlaceViewController(reactor: OnboardingHowToNewPlaceReactor) {
        let onboardingHowToNewPlaceViewController = OnboardingHowToNewPlaceViewController()
        onboardingHowToNewPlaceViewController.reactor = reactor
        navigationController?.pushViewController(onboardingHowToNewPlaceViewController, animated: true)
    }
}

// MARK: - Setup Binding Actions

extension OnboardingWhatIsJourneyViewController {
    func bindActions(to reactor: OnboardingWhatIsJourneyReactor) {
        bindDidTapCardViewA(to: reactor)
        bindDidTapCardViewB(to: reactor)
        bindDidTapNextButton(to: reactor)
    }
    
    func bindDidTapCardViewA(to reactor: OnboardingWhatIsJourneyReactor) {
        selfView.onboardingCardViewA.rx.tapGesture()
            .filter { $0.state == .ended }
            .map { _ in .didTapCardViewA }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindDidTapCardViewB(to reactor: OnboardingWhatIsJourneyReactor) {
        selfView.onboardingCardViewB.rx.tapGesture()
            .filter { $0.state == .ended }
            .map { _ in .didTapCardViewB }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindDidTapNextButton(to reactor: OnboardingWhatIsJourneyReactor) {
        selfView.nextButton.rx.tap
            .map { .didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup Binding States

extension OnboardingWhatIsJourneyViewController {
    func bindStates(from reactor: OnboardingWhatIsJourneyReactor) {
        bindStateCardViewA(from: reactor)
        bindStateCardViewB(from: reactor)
        bindIsActiveNextButton(from: reactor)
        bindIsPresentOnboardingHowToNewPlaceReactor(from: reactor)
    }
    
    func bindStateCardViewA(from reactor: OnboardingWhatIsJourneyReactor) {
        reactor.state
            .map { $0.stateCardViewA }
            .bind { [weak self] state in
                self?.selfView.onboardingCardViewA.state = state
            }
            .disposed(by: disposeBag)
    }
    
    func bindStateCardViewB(from reactor: OnboardingWhatIsJourneyReactor) {
        reactor.state
            .map { $0.stateCardViewB }
            .bind { [weak self] state in
                self?.selfView.onboardingCardViewB.state = state
            }
            .disposed(by: disposeBag)
    }
    
    func bindIsActiveNextButton(from reactor: OnboardingWhatIsJourneyReactor) {
        reactor.state
            .map { $0.isActiveNextButton }
            .bind { [weak self] bool in
                self?.selfView.nextButton.isEnabled = bool
            }
            .disposed(by: disposeBag)
    }
    
    func bindIsPresentOnboardingHowToNewPlaceReactor(from reactor: OnboardingWhatIsJourneyReactor) {
        reactor.state
            .map { $0.isPresentOnboardingHowToNewPlaceReactor }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in reactor.getOnboardingHowToNewPlaceReactor() }
            .bind(onNext: presentOnboardingHowToNewPlaceViewController)
            .disposed(by: disposeBag)
    }
}
