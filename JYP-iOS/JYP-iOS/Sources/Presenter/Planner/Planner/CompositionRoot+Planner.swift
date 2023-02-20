//
//  CompositionRoot+Planner.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/02/20.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import Foundation

extension CompositionRoot {
    func makePlannerScreen(id: String,
                           journeyService: JourneyServiceType,
                           pushPlannerInviteScreen: @escaping (_ id: String) -> PlannerInviteViewController,
                           pushPlannerRouteScreen: @escaping (_ root: AnyObject.Type, _ journey: Journey, _ order: Int) -> PlannerRouteViewController,
                           pushWebScreen: @escaping (_ url: String) -> WebViewController,
                           pushJourneyPlanScreen: @escaping () -> JourneyPlanView,
                           pushDiscussionScreen: @escaping () -> DiscussionView) {
        let reactor = PlannerReactor(id: id, journeyService: journeyService)
        let viewController = PlannerViewController(reactor: reactor,
                                                   pushPlannerInviteScreen: pushPlannerInviteScreen,
                                                   pushPlannerRouteScreen: pushPlannerRouteScreen,
                                                   pushWebScreen: pushWebScreen,
                                                   pushJourneyPlanScreen: pushJourneyPlanScreen,
                                                   pushDiscussionScreen: pushDiscussionScreen)
    }
}
