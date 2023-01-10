//
//  CompositionRoot.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/12/28.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

struct AppDependency {
    let window: UIWindow
    let configureAppearance: () -> Void
}

final class CompositionRoot {
    static func resolve(windowScene: UIWindowScene) -> AppDependency {
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        
        if 
        window.rootViewController = makeTabBarScreen()
        
        return AppDependency(window: window,
                             configureAppearance: self.configureAppearance)
    }
     
    static func configureAppearance() { }
}

extension CompositionRoot {
    static func makeTabBarScreen() -> TabBarViewController {
        let viewController = TabBarViewController()
        
        let myPlannerViewController = makeMyPlannerScreen()
        let anotherJourneyViewController = makeAnotherJourneyScreen()
        let myPageViewController = makeMyPageScreen()
        
        viewController.viewControllers = [
            UINavigationController(rootViewController: myPlannerViewController),
            UINavigationController(rootViewController: anotherJourneyViewController),
            UINavigationController(rootViewController: myPageViewController)
        ]

        return viewController
    }
    
    static func makeMyPlannerScreen() -> MyPlannerViewController {
        let journeyService: JourneyServiceType = JourneyService(provider: ServiceProvider.shared)
        
        let pushPlannerInviteScreen: (_ id: String) -> PlannerInviteViewController = { (id) in
            let reactor = PlannerInviteReactor(id: id)
            let controller = PlannerInviteViewController(reactor: reactor)
            
            return controller
        }
        
        let pushPlannerRouteScreen: (_ root: AnyObject.Type, _ journey: Journey, _ order: Int) -> PlannerRouteViewController = { (root, journey, order) in
            let reactor = PlannerRouteReactor(journey: journey, order: order, journeyService: journeyService)
            let controller = PlannerRouteViewController(reactor: reactor, root: PlannerViewController.self)
            
            return controller
        }
        
        let pushPlannerScreen: (_ id: String) -> PlannerViewController = { (id) in
            let reactor = PlannerReactor(id: id)
            let controller = PlannerViewController(reactor: reactor,
                                                   pushPlannerInviteScreen: pushPlannerInviteScreen,
                                                   pushPlannerRouteScreen: pushPlannerRouteScreen)
            
            return controller
        }
        
        let pushInputPlannerCodeBottomSheetScreen: () -> InputPlannerCodeBottomSheetViewController = {
            let reactor = InputPlannerCodeBottomSheetReactor()
            let controller = InputPlannerCodeBottomSheetViewController(reactor: reactor,
                                                                       pushPlannerInviteScreen: pushPlannerInviteScreen)
            
            return controller
        }
        
        let pushSelectionPlannerJoinBottomScreen: () -> SelectionPlannerJoinBottomViewController = {
            let controller = SelectionPlannerJoinBottomViewController(mode: .drag,
                                                                      pushInputPlannerCodeBottomSheetScreen: pushInputPlannerCodeBottomSheetScreen)
            
            return controller
        }
        
        let reactor = MyPlannerReactor()
        let viewController = MyPlannerViewController(reactor: reactor,
                                                     pushSelectionPlannerJoinBottomScreen: pushSelectionPlannerJoinBottomScreen,
                                                     pushPlannerScreen: pushPlannerScreen)
        let tabBarItem = UITabBarItem(title: nil,
                                      image: JYPIOSAsset.myJourneyInactive.image.withRenderingMode(.alwaysOriginal),
                                      selectedImage: JYPIOSAsset.myJourneyActive.image.withRenderingMode(.alwaysOriginal))
        
        tabBarItem.imageInsets = .init(top: 9, left: 0, bottom: -9, right: 0)
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }
    
    static func makeAnotherJourneyScreen() -> AnotherJourneyViewController {
        let viewController = AnotherJourneyViewController()
        let tabBarItem = UITabBarItem(title: nil,
                                      image: JYPIOSAsset.anotherJourneyInactive.image.withRenderingMode(.alwaysOriginal),
                                      selectedImage: JYPIOSAsset.anotherJourneyActive.image.withRenderingMode(.alwaysOriginal))
        
        tabBarItem.imageInsets = .init(top: 9, left: 0, bottom: -9, right: 0)
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }
    
    static func makeMyPageScreen() -> MyPageViewController {
        let viewController = MyPageViewController()
        let tabBarItem = UITabBarItem(title: nil,
                                      image: JYPIOSAsset.myPageInactive.image.withRenderingMode(.alwaysOriginal),
                                      selectedImage: JYPIOSAsset.myPageActive.image.withRenderingMode(.alwaysOriginal))
        
        tabBarItem.imageInsets = .init(top: 9, left: 0, bottom: -9, right: 0)
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }
}
