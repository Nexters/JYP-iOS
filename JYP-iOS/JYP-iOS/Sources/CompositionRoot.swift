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
    let configureSDKs: () -> Void
    let configureAppearance: () -> Void
}

class CompositionRoot {
    static func resolve(windowScene: UIWindowScene) -> AppDependency {
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        
        window.rootViewController = makeTabBarScreen()
        
        return AppDependency(window: window,
                             configureSDKs: self.configureSDKs,
                             configureAppearance: self.configureAppearance)
    }
    
    static func configureSDKs() { }
    
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
        let pushPlannerScreen: (_ id: String) -> PlannerViewController = { (id) in
            let reactor = PlannerReactor(id: id)
            let controller = PlannerViewController(reactor: reactor)
            
            return controller
        }
        
        let reactor = MyPlannerReactor()
        let viewController = MyPlannerViewController(reactor: reactor, pushPlannerScreen: pushPlannerScreen)
        let tabBarItem = UITabBarItem(title: nil, image: JYPIOSAsset.myJourneyInactive.image.withRenderingMode(.alwaysOriginal), selectedImage: JYPIOSAsset.myJourneyActive.image.withRenderingMode(.alwaysOriginal))
        
        tabBarItem.imageInsets = .init(top: 9, left: 0, bottom: -9, right: 0)
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }
    
    static func makeAnotherJourneyScreen() -> AnotherJourneyViewController {
        let viewController = AnotherJourneyViewController()
        let tabBarItem = UITabBarItem(title: nil, image: JYPIOSAsset.anotherJourneyInactive.image.withRenderingMode(.alwaysOriginal), selectedImage: JYPIOSAsset.anotherJourneyActive.image.withRenderingMode(.alwaysOriginal))
        
        tabBarItem.imageInsets = .init(top: 9, left: 0, bottom: -9, right: 0)
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }
    
    static func makeMyPageScreen() -> MyPageViewController {
        let viewController = MyPageViewController()
        let tabBarItem = UITabBarItem(title: nil, image: JYPIOSAsset.myPageInactive.image.withRenderingMode(.alwaysOriginal), selectedImage: JYPIOSAsset.myPageActive.image.withRenderingMode(.alwaysOriginal))
        
        tabBarItem.imageInsets = .init(top: 9, left: 0, bottom: -9, right: 0)
        viewController.tabBarItem = tabBarItem
        
        return viewController
    }
//    static func makeTabBarScreen() -> TabBarViewController {
//
//        let walkService: WalkServiceType = WalkService()
//
//        let tabBarViewController = TabBarViewController()
//        let footprintRootViewController = makeFootprintRootScreen(walkService: walkService)
//        let calendarViewController = makeCalendarScreen()
//        let recommendViewController = makeRecommendScreen()
//        let myPageViewController = makeMyPageScreen()
//
//        tabBarViewController.viewControllers = [
//            footprintRootViewController.navigationWrap(),
//            calendarViewController.navigationWrap(),
//            recommendViewController.navigationWrap(),
//            myPageViewController.navigationWrap()
//        ]
//
//        return tabBarViewController
//    }
//
//    static func makeFootprintRootScreen(walkService: WalkServiceType) -> FootprintRootViewController {
//        let pushFootprintWriteScreen: () -> FootprintWriteViewController = {
//            let reactor = FootprintWriteReactor(state: .init())
//            let controller = FootprintWriteViewController(reactor: reactor)
//            return controller
//        }
//
//        let pushFootprintMapScreen: () -> FootprintMapViewController = {
//            let reactor = FootprintMapReactor(state: .init())
//            let controller = FootprintMapViewController(reactor: reactor,
//                                                        pushFootprintWriteScreen: pushFootprintWriteScreen)
//            return controller
//        }
//
//        let pushRecordSearchScreen: (Int) -> RecordSearchViewController = { (id) in
//            let reactor: RecordSearchReactor = .init(id: id, walkService: walkService)
//            return .init(reactor: reactor)
//        }
//
//        let reactor = FootprintRootReactor(state: .init())
//        let controller = FootprintRootViewController(reactor: reactor,
//                                                     pushFootprintMapScreen: pushFootprintMapScreen,
//                                                     pushRecordSearchScreen: pushRecordSearchScreen)
//
//        controller.title = "홈"
//        controller.tabBarItem.image = nil
//        controller.tabBarItem.selectedImage = nil
//        return controller
//    }
}
