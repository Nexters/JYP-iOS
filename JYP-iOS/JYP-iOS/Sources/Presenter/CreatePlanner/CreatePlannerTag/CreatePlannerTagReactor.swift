//
//  CreatePlannerTagReactor.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/09.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import ReactorKit
import RxDataSources

final class CreatePlannerTagReactor: Reactor {
    enum Action {}

    enum Mutation {}

    struct State {
        var sections: [TagSectionModel]
    }

    let initialState: State

    init() {
        initialState = State(sections: CreatePlannerTagReactor.makeSections())
    }
}

extension CreatePlannerTagReactor {
    static func makeSections() -> [TagSectionModel] {
        let tags: [Tag] = [.init(id: "1", text: "모두 찬성", type: .soso), .init(id: "2", text: "상관없어", type: .soso), .init(id: "3", text: "고기", type: .like)]

        let sosoSection = TagSectionModel(model: .soso(tags), items: tags.map(TagSectionModel.Item.tagCell))
        let likeSection = TagSectionModel(model: .like(tags), items: tags.map(TagSectionModel.Item.tagCell))
        let disLikeSection = TagSectionModel(model: .dislike(tags), items: tags.map(TagSectionModel.Item.tagCell))

        return [sosoSection, likeSection, disLikeSection]
    }
}
