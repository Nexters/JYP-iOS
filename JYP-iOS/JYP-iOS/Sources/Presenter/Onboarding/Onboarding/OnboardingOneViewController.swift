//
//  OnboardingLikingViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/31.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

final class OnboardingOneViewController: NavigationBarViewController {
    // MARK: - Properties
    
    private let pushOnboardingTwoScreen: () -> OnboardingTwoViewController
    
    // MARK: - UI Components
    
    var onboardingView = OnboardingView(type: .one)
    
    // MARK: - Initializer
    
    init(pushOnboardingTwoScreen: @escaping () -> OnboardingTwoViewController) {
        self.pushOnboardingTwoScreen = pushOnboardingTwoScreen
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
     
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
    
    override func setupBind() {
        super.setupBind()
        
        onboardingView.nextButton.rx.tap
            .bind { [weak self] _ in
                self?.willPushOnboardingTwoViewController()
            }
            .disposed(by: disposeBag)
    }
}

extension OnboardingOneViewController {
    func willPushOnboardingTwoViewController() {
        let viewController = self.pushOnboardingTwoScreen()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
