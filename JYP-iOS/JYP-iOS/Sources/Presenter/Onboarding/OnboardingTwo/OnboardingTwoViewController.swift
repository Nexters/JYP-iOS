//
//  OnboardingPlaceViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/31.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class OnboardingTwoViewController: NavigationBarViewController, View {
    typealias Reactor = OnboardingTwoReactor
    
    // MARK: - UI Components
    
    var onboardingView = OnboardingView(type: .two)
    
    // MARK: - Setup Methods
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(reactor: OnboardingTwoReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        setNavigationBarHidden(true)
    }
    
    override func setupProperty() {
        super.setupProperty()
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubview(onboardingView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        onboardingView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: Binding
    
    func bind(reactor: OnboardingTwoReactor) {
        // Action
        onboardingView.nextButton.rx.tap
            .map { .didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state
            .map { $0.isPresentOnboardingSignUp }
            .distinctUntilChanged()
            .filter { $0 }
            .bind { [weak self] _ in
                let onboardingSignUpViewController = OnboardingSignUpViewController(reactor: OnboardingSignUpReactor(initialState: .init()))
                self?.navigationController?.pushViewController(onboardingSignUpViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
