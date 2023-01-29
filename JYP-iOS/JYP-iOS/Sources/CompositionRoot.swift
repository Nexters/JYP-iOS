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

        let authService: AuthServiceType = AuthService()
        let userService: UserServiceType = UserService()
        let onboardingService: OnboardingServiceType = OnboardingService()
        
        lazy var pushOnboardingScreen: () -> OnboardingOneViewController = {
            return makeOnboardingScreen(onboardingService: onboardingService,
                                        authService: authService,
                                        userService: userService,
                                        pushTabBarScreen: pushTabBarScreen)
        }
        
        lazy var pushTabBarScreen: () -> TabBarViewController = {
            return makeTabBarScreen(pushOnboardingScreen: pushOnboardingScreen)
        }
        
        if KeychainAccess.get(key: .accessToken) != nil && UserDefaultsAccess.get(key: .userID) != nil {
            window.rootViewController = pushTabBarScreen()
        } else {
            window.rootViewController = pushOnboardingScreen().navigationWrap()
        }

        return AppDependency(
            window: window,
            configureAppearance: self.configureAppearance
        )
    }

    static func configureAppearance() { }
}

extension CompositionRoot {
    static func makeTabBarScreen(pushOnboardingScreen: @escaping () -> OnboardingOneViewController) -> TabBarViewController {
        let viewController = TabBarViewController()

        let myPlannerViewController = makeMyPlannerScreen()
        let anotherJourneyViewController = makeAnotherJourneyScreen()
        
        let myPageViewController = makeMyPageScreen(pushOnboardingScreen: pushOnboardingScreen)

        viewController.viewControllers = [
            myPlannerViewController.navigationWrap(),
            anotherJourneyViewController.navigationWrap(),
            myPageViewController.navigationWrap()
        ]

        return viewController
    }

    static func makeOnboardingScreen(onboardingService: OnboardingServiceType,
                                     authService: AuthServiceType,
                                     userService: UserServiceType,
                                     pushTabBarScreen: @escaping () -> TabBarViewController) -> OnboardingOneViewController {
        let pushOnboardingQuestionPlanScreen: () -> OnboardingQuestionPlanViewController = {
            let reactor = OnboardingQuestionReactor(mode: .plan,
                                                    onboardingService: onboardingService,
                                                    userService: userService)
            let viewController = OnboardingQuestionPlanViewController(reactor: reactor,
                                                                      pushTabBarScreen: pushTabBarScreen)

            return viewController
        }

        let pushOnboardingQuestionPlaceScreen: () -> OnboardingQuestionPlaceViewController = {
            let reactor = OnboardingQuestionReactor(mode: .place,
                                                    onboardingService: onboardingService,
                                                    userService: userService)
            let viewController = OnboardingQuestionPlaceViewController(reactor: reactor, pushOnboardingQuestionPlanScreen: pushOnboardingQuestionPlanScreen)

            return viewController
        }

        let pushOnboardingQuestionJourneyScreen: () -> OnboardingQuestionJourneyViewController = {
            let reactor = OnboardingQuestionReactor(mode: .joruney,
                                                    onboardingService: onboardingService,
                                                    userService: userService)
            let viewController = OnboardingQuestionJourneyViewController(reactor: reactor,
                                                                         pushOnboardingQuestionPlaceScreen: pushOnboardingQuestionPlaceScreen)

            return viewController
        }

        let pushOnboardingSignUpScreen: () -> OnboardingSignUpViewController = {
            let reactor = OnboardingSignUpReactor(authService: authService)
            let viewController = OnboardingSignUpViewController(reactor: reactor, pushOnboardingQuestionJourneyScreen: pushOnboardingQuestionJourneyScreen)

            return viewController
        }

        let pushOnboardingTwoScreen: () -> OnboardingTwoViewController = {
            let viewController = OnboardingTwoViewController(pushOnboardingSignUpScreen: pushOnboardingSignUpScreen)
            return viewController
        }

        let viewController = OnboardingOneViewController(pushOnboardingTwoScreen: pushOnboardingTwoScreen)

        return viewController
    }

    static func makeMyPlannerScreen() -> MyPlannerViewController {
        let journeyService: JourneyServiceType = JourneyService(provider: ServiceProvider.shared)

        let pushPlannerInviteScreen: (_ id: String) -> PlannerInviteViewController = { id in
            let reactor = PlannerInviteReactor(id: id)
            let controller = PlannerInviteViewController(reactor: reactor)

            return controller
        }

        let pushPlannerRouteScreen: (_ root: AnyObject.Type, _ journey: Journey, _ order: Int) -> PlannerRouteViewController = { root, journey, order in
            let reactor = PlannerRouteReactor(journey: journey, order: order, journeyService: journeyService)
            let controller = PlannerRouteViewController(reactor: reactor, root: PlannerViewController.self)

            return controller
        }

        let pushPlannerScreen: (_ id: String) -> PlannerViewController = { id in
            let reactor = PlannerReactor(id: id)
            let controller = PlannerViewController(reactor: reactor,
                                                   pushPlannerInviteScreen: pushPlannerInviteScreen,
                                                   pushPlannerRouteScreen: pushPlannerRouteScreen)

            return controller
        }

        let pushJoinPlannerTagScreen: (_ id: String) -> CreatePlannerTagViewController = { id in
            let reactor = CreatePlannerTagReactor(
                provider: ServiceProvider.shared,
                journey: .init(id: id, name: "", startDate: 0.0, endDate: 0.0, themePath: .default, users: []),
                viewMode: .join
            )
            let viewController = CreatePlannerTagViewController(
                reactor: reactor,
                pushPlannerScreen: pushPlannerScreen
            ) { error in
                JoinErrorBottomSheetViewController(error: error)
            }
            return viewController
        }

        let pushInputPlannerCodeBottomSheetScreen: () -> InputPlannerCodeBottomSheetViewController = {
            let reactor = InputPlannerCodeBottomSheetReactor()
            let controller = InputPlannerCodeBottomSheetViewController(
                reactor: reactor,
                pushJoinPlannerTagScreen: pushJoinPlannerTagScreen
            )

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

    static func makeMyPageScreen(pushOnboardingScreen: @escaping () -> OnboardingOneViewController) -> MyPageViewController {
        let reactor = MyPageReactor()
        let viewController = MyPageViewController(reactor: reactor,
                                                  pushOnboardingScreen: pushOnboardingScreen)

        let tabBarItem = UITabBarItem(title: nil,
                                      image: JYPIOSAsset.myPageInactive.image.withRenderingMode(.alwaysOriginal),
                                      selectedImage: JYPIOSAsset.myPageActive.image.withRenderingMode(.alwaysOriginal))

        tabBarItem.imageInsets = .init(top: 9, left: 0, bottom: -9, right: 0)
        viewController.tabBarItem = tabBarItem

        return viewController
    }
}
