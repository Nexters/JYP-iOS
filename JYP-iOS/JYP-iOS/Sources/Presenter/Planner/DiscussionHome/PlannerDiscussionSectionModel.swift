//
//  DiscussionHomeJYPTagSectionModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias PlannerDiscussionSectionModel = SectionModel<PlannerDiscussionSection, PlannerDiscussionItem>

enum PlannerDiscussionSection: Equatable {
    case journeyTag([Tag])
    case candidatePlace([CandidatePlace])
}

enum PlannerDiscussionItem: Equatable {
    case tagCell(Tag)
    case candidatePlaceCell(CandidatePlace)
}

extension PlannerDiscussionSection: SectionModelType {
    typealias Item = Any

    var items: [Any] {
        switch self {
        case .journeyTag(let array):
            return array
        case .candidatePlace(let array):
            return array
        }
    }
    
    init(original: PlannerDiscussionSection, items: [Any]) {
        switch original {
        case .journeyTag(let array):
            self = .journeyTag(array)
        case .candidatePlace(let array):
            self = .candidatePlace(array)
        }
    }
}
