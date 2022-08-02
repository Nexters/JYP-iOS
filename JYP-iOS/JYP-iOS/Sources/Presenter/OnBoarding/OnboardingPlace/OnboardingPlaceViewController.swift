//
//  OnboardingPlaceViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/31.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class OnboardingPlaceViewController: BaseViewController, View {
    typealias Reactor = OnboardingPlaceReactor
    
    // MARK: - UI Components
    
    var selfView: OnboardingPlaceView!
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        selfView = .init()
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubview(selfView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        selfView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func bind(reactor: OnboardingPlaceReactor) { }
}
