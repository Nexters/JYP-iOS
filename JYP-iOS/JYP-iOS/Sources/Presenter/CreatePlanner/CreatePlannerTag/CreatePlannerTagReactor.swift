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
    enum Action {
        case selectTag(IndexPath)
    }

    enum Mutation {
        case toggleTagSelection(IndexPath, TagSectionModel.Item)
    }

    struct State {
        var sections: [TagSectionModel]
        var isSelected: Bool = false
    }

    let initialState: State

    init() {
        initialState = State(sections: CreatePlannerTagReactor.makeSections())
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectTag(indexPath):
            var tag = currentState.sections[indexPath.section].model.items[indexPath.row]
            tag.isSelected = true

            return .just(.toggleTagSelection(indexPath, TagItem.tagCell(tag)))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState: State = state

        switch mutation {
        case let .toggleTagSelection(indexPath, tag):
            let section = tag
            newState.sections[indexPath.section].items[indexPath.row] = tag
        }

        return newState
    }
}

extension CreatePlannerTagReactor {
    static func makeSections() -> [TagSectionModel] {
        let tags: [Tag] = [.init(id: "1", text: "모두 찬성", type: .soso), .init(id: "2", text: "상관없어", type: .soso), .init(id: "3", text: "고기", type: .like), .init(id: "4", text: "해산물", type: .like), .init(id: "5", text: "쇼핑", type: .like), .init(id: "6", text: "산", type: .like), .init(id: "7", text: "바다", type: .like), .init(id: "8", text: "도시", type: .like), .init(id: "9", text: "핫 플레이스", type: .like), .init(id: "10", text: "민초 치킨", type: .dislike), .init(id: "11", text: "단팥크림빵", type: .dislike), .init(id: "12", text: "약", type: .dislike)]

        let sosoSection = TagSectionModel(model: .soso(tags.filter { $0.type == .soso }), items: tags.filter { $0.type == .soso }.map(TagSectionModel.Item.tagCell))
        let likeSection = TagSectionModel(model: .like(tags.filter { $0.type == .like }), items: tags.filter { $0.type == .like }.map(TagSectionModel.Item.tagCell))
        let dislikeSection = TagSectionModel(model: .dislike(tags.filter { $0.type == .dislike }), items: tags.filter { $0.type == .dislike }.map(TagSectionModel.Item.tagCell))

        return [sosoSection, likeSection, dislikeSection]
    }
}
