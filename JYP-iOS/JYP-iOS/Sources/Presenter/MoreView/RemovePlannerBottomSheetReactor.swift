//
//  RemovePlannerBottomSheetReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2023/01/29.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import ReactorKit

final class RemovePlannerBottomSheetReactor: Reactor {
    enum Action {}

    enum Mutation {}

    struct State {
        let journey: Journey
    }

    var initialState: State

    private let journeyService: JourneyServiceType

    init(journeyService: JourneyServiceType, journey: Journey) {
        self.journeyService = journeyService
        self.initialState = .init(journey: journey)
    }
}
