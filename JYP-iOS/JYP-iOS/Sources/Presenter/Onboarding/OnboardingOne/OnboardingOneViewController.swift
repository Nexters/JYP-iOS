//
//  OnboardingLikingViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/31.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class OnboardingOneViewController: NavigationBarViewController, View {
    typealias Reactor = OnboardingOneReactor
    
    // MARK: - UI Components
    
    var onboardingView = OnboardingView(type: .one)
     
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
        
        contentView.addSubview(onboardingView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        onboardingView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Binding
    
    func bind(reactor: OnboardingOneReactor) {
        onboardingView.nextButton.rx.tap
            .map { .didTapNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isPresentOnboardingPlace }
            .distinctUntilChanged()
            .filter { $0 }
            .bind { [weak self] _ in
                let onboardingTwoViewController = OnboardingTwoViewController(reactor: OnboardingTwoReactor(initialState: .init()))
                self?.navigationController?.pushViewController(onboardingTwoViewController, animated: true)  
            }
            .disposed(by: disposeBag)
    }
}
