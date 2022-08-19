//
//  PastJourneyModel.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/20.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias PastJourneySectionModel = SectionModel<Void, JourneyCardItem>

enum PastJourneyCardItem {
    case empty
    case journey(JourneyCardCollectionViewCellReactor)
}
