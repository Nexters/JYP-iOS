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
        
        let onboardingService: OnboardingServiceType = OnboardingService()

        lazy var pushOnboardingScreen: () -> OnboardingOneViewController = {
            let authService: AuthServiceType = AuthService()
            let userService: UserServiceType = UserService()
            
            return makeOnboardingScreen(onboardingService: onboardingService,
                                        authService: authService,
                                        userService: userService,
                                        pushTabBarScreen: pushTabBarScreen)
        }
        
        lazy var pushTabBarScreen: () -> TabBarViewController = {
            let userService: UserServiceType = UserService()
            
            let pushCreateProfileBottomSheetScreen: () -> CreateProfileBottomSheetViewController = {
                let reactor = CreateProfileBottomSheetReactor(onboardingService: onboardingService,
                                                              userService: userService)
                let viewController = CreateProfileBottomSheetViewController(reactor: reactor)
                
                return viewController
            }
            
            return makeTabBarScreen(userService: userService,
                                    pushOnboardingScreen: pushOnboardingScreen,
                                    pushCreateProfileBottomSheetScreen: pushCreateProfileBottomSheetScreen)
        }
        
        if UserDefaultsAccess.get(key: .accessToken) != nil && UserDefaultsAccess.get(key: .userID) != nil {
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
    static func makeTabBarScreen(userService: UserServiceType,
                                 pushOnboardingScreen: @escaping () -> OnboardingOneViewController,
                                 pushCreateProfileBottomSheetScreen: @escaping () -> CreateProfileBottomSheetViewController) -> TabBarViewController {
        let reactor = TabBarReactor()
        let viewController = TabBarViewController(reactor: reactor, pushCreateProfileBottomSheetScreen: pushCreateProfileBottomSheetScreen)

        let myPlannerViewController = makeMyPlannerScreen(userService: userService)
        let anotherJourneyViewController = makeAnotherJourneyScreen()
        
        let myPageViewController = makeMyPageScreen(pushOnboardingScreen: pushOnboardingScreen,
                                                    userService: userService)

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
            let reactor = OnboardingSignUpReactor(authService: authService,
                                                  userService: userService)
            let viewController = OnboardingSignUpViewController(reactor: reactor,
                                                                pushOnboardingQuestionJourneyScreen: pushOnboardingQuestionJourneyScreen,
                                                                pushTabBarScreen: pushTabBarScreen)

            return viewController
        }

        let pushOnboardingTwoScreen: () -> OnboardingTwoViewController = {
            let viewController = OnboardingTwoViewController(pushOnboardingSignUpScreen: pushOnboardingSignUpScreen)
            return viewController
        }

        let viewController = OnboardingOneViewController(pushOnboardingTwoScreen: pushOnboardingTwoScreen)

        return viewController
    }

    static func makeMyPlannerScreen(userService: UserServiceType) -> MyPlannerViewController {
        let journeyService: JourneyServiceType = ServiceProvider.shared.journeyService

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

        let presentRemovePlannerBottomSheetScreen: (_ journey: Journey) -> RemovePlannerBottomSheetViewController = { journey in
            let reactor = RemovePlannerBottomSheetReactor(
                journeyService: journeyService,
                journey: journey
            )

            return RemovePlannerBottomSheetViewController(reactor: reactor)
        }

        let presentPlannerMoreScreen: (_ journey: Journey) -> PlannerMoreButtomSheetViewController = { journey in
            return PlannerMoreButtomSheetViewController(
                journey: journey,
                presentRemovePlannerBottomSheetScreen: presentRemovePlannerBottomSheetScreen
            )
        }

        let reactor = MyPlannerReactor(journeyService: journeyService,
                                       userService: userService)
        let viewController = MyPlannerViewController(
            reactor: reactor,
            pushSelectionPlannerJoinBottomScreen: pushSelectionPlannerJoinBottomScreen,
            pushPlannerScreen: pushPlannerScreen,
            presentPlannerMoreScreen: presentPlannerMoreScreen
        )
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

    static func makeMyPageScreen(pushOnboardingScreen: @escaping () -> OnboardingOneViewController,
                                 userService: UserServiceType) -> MyPageViewController {
        let pushLogoutBottomSheetScreen: () -> LogoutBottomSheetViewController = {
            let reactor = LogoutBottomSheetReactor(userService: userService)
            let viewController = LogoutBottomSheetViewController(reactor: reactor)
            
            return viewController
        }
        
        let pushWithdrawBottomSheetScreen: () -> WithdrawBottomSheetViewController = {
            let reactor = WithdrawBottomSheetReactor(userService: userService)
            let viewController = WithdrawBottomSheetViewController(reactor: reactor)
            
            return viewController
        }
        
        let reactor = MyPageReactor(userService: userService)
        let viewController = MyPageViewController(reactor: reactor,
                                                  pushOnboardingScreen: pushOnboardingScreen,
                                                  pushLogoutBottomSheetScreen: pushLogoutBottomSheetScreen,
                                                  pushWithdrawBottomSheetScreen: pushWithdrawBottomSheetScreen)

        let tabBarItem = UITabBarItem(title: nil,
                                      image: JYPIOSAsset.myPageInactive.image.withRenderingMode(.alwaysOriginal),
                                      selectedImage: JYPIOSAsset.myPageActive.image.withRenderingMode(.alwaysOriginal))

        tabBarItem.imageInsets = .init(top: 9, left: 0, bottom: -9, right: 0)
        viewController.tabBarItem = tabBarItem

        return viewController
    }
}
