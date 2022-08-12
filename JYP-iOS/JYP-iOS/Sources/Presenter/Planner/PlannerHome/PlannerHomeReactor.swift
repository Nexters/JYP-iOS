//
//  DiscussionHomeReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/11.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

final class PlannerHomeReactor: Reactor {
    enum Action {}

    enum Mutation {}

    struct State {
        var sections: [PlannerHomeDiscussionSectionModel]
    }

    let initialState: State

    init() {
        initialState = State(sections: PlannerHomeReactor.makeSections())
    }
}

extension PlannerHomeReactor {
    static func makeSections() -> [PlannerHomeDiscussionSectionModel] {
        let tags: [Tag] = [.init(id: "1", text: "바다", type: .like), .init(id: "2", text: "해산물", type: .like), .init(id: "3", text: "산", type: .like), .init(id: "4", text: "핫 플레이스", type: .dislike), .init(id: "5", text: "도시", type: .dislike), .init(id: "6", text: "상관없어", type: .soso)]
        
        let candidatePlaces: [CandidatePlace] = [.init(id: "1", name: "아르떼 뮤지엄", address: "강원 강릉시 난설헌로 131", category: .culture, like: "1", lon: 0.124, lan: 0.124, url: "")]
        
//        let journeyTagSection = PlannerDiscussionSectionModel(model: .journeyTag(tags), items: tags.map(PlannerDiscussionSectionModel.Item.tagCell))
//        let candidatePlaceSection = PlannerDiscussionSectionModel(model: .candidatePlace(candidatePlaces), items: candidatePlaces.map(PlannerDiscussionSectionModel.Item.candidatePlaceCell))
        
        let jypTagItems = tags.map { (tag) -> PlannerHomeDiscussionItem in
            return .jypTagItem(.init(tag: tag))
        }
        let jypTagSection = PlannerHomeDiscussionSectionModel(model: .jypTagSection(jypTagItems), items: jypTagItems)
        
        let candidatePlaceItems = candidatePlaces.map { (candidatePlace) -> PlannerHomeDiscussionItem in
            return .candidatePlaceItem(.init(candidatePlace: candidatePlace))
        }
        let candidatePlaceSection = PlannerHomeDiscussionSectionModel(model: .candidatePlaceSection(candidatePlaceItems), items: candidatePlaceItems)
        
        return [jypTagSection, candidatePlaceSection]
    }
}
