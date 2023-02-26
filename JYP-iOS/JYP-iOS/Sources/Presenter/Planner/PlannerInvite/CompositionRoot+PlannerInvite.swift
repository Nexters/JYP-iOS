//
//  CompositionRoot+PlannerInvite.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/02/25.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

extension CompositionRoot {
    func makePlannerInviteScreen(id: String) -> PlannerInviteViewController {
        let reactor = PlannerInviteReactor(id: id)
        let viewController = PlannerInviteViewController(reactor: reactor)
        
        return viewController
    }
}
