//
//  ScheduledJourneyModel.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/16.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias ScheduledJourneySectionModel = SectionModel<Void, JourneyCardItem>

enum JourneyCardItem {
    case empty
    case journey(JourneyCardCollectionViewCellReactor)
}
