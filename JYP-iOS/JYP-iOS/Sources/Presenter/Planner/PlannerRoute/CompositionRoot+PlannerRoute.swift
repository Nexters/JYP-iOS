//
//  CompositionRoot+PlannerRoute.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/02/20.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

extension CompositionRoot {
    func makePlannerRouteScreen(journey: Journey, order: Int, journeyService: JourneyServiceType) -> PlannerRouteViewController {
        let reactor = PlannerRouteReactor(journey: journey,
                                          order: order,
                                          journeyService: journeyService)
        let viewController = PlannerRouteViewController(reactor: reactor)
    }
}
