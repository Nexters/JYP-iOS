//
//  TabBarViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/17.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import UIKit
import ReactorKit

class TabBarViewController: UITabBarController, View {
    // MARK: - Properties
    
    typealias Reactor = TabBarReactor
    
    private let pushCreateProfileBottomSheetScreen: () -> CreateProfileBottomSheetViewController
    
    var disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    init(reactor: Reactor,
         pushCreateProfileBottomSheetScreen: @escaping () -> CreateProfileBottomSheetViewController) {
        self.pushCreateProfileBottomSheetScreen = pushCreateProfileBottomSheetScreen
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecylce
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        tabBar.layer.borderWidth = 1.0
        tabBar.layer.borderColor = .init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
    }

    func bind(reactor: Reactor) {
        rx.viewDidLoad
            .filter { _ in UserDefaultsAccess.get(key: .userID) != nil }
            .subscribe(onNext: { [weak self] _ in
                self?.willPresentCreateProfileBottomSheetViewController()
            })
            .disposed(by: disposeBag)
    }
}
extension TabBarViewController {
    func willPresentCreateProfileBottomSheetViewController() {
        let viewController = pushCreateProfileBottomSheetScreen()
        
        tabBarController?.present(viewController, animated: true)
    }
}
