//
//  OnboardingPlaceViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/31.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

final class OnboardingTwoViewController: NavigationBarViewController {
    // MARK: - Properties
    
    private let pushOnboardingSignUpScreen: () -> OnboardingSignUpViewController
    
    // MARK: - UI Components
    
    var onboardingView = OnboardingView(type: .two)
    
    // MARK: - Setup Methods
    
    init(pushOnboardingSignUpScreen: @escaping () -> OnboardingSignUpViewController) {
        self.pushOnboardingSignUpScreen = pushOnboardingSignUpScreen
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func setupBind() {
        super.setupBind()
        
        onboardingView.nextButton.rx.tap
            .bind { [weak self] _ in
                self?.willPushOnboardingSignUpViewController()
            }
            .disposed(by: disposeBag)
    }
}

extension OnboardingTwoViewController {
    func willPushOnboardingSignUpViewController() {
        let viewController = pushOnboardingSignUpScreen()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
