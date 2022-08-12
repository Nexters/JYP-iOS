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
        case updateSectionItem(IndexPath, [TagItem])
    }

    struct State {
        var sections: [TagSectionModel]
    }

    let initialState: State

    init() {
        initialState = State(sections: CreatePlannerTagReactor.makeSections())
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .selectTag(indexPath):
            /// current Tag -> isSelecte toggle -> new Tag -> items 배열 replace
            var items = currentState.sections[indexPath.section].items
            let currentTag = items[indexPath.row]

            guard case let TagItem.tagCell(reactor) = currentTag else { return .empty() }
            var newTag = reactor.currentState
            newTag.isSelected.toggle()

            items.replaceSubrange(indexPath.row ... indexPath.row, with: [.tagCell(JYPTagCollectionViewCellReactor(tag: newTag))])
            return .just(.updateSectionItem(indexPath, items))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState: State = state

        switch mutation {
        case let .updateSectionItem(indexPath, tags):
            newState.sections[indexPath.section].items = tags
        }

        return newState
    }
}

extension CreatePlannerTagReactor {
    static func makeSections() -> [TagSectionModel] {
        let tags: [Tag] = [.init(id: "1", text: "모두 찬성", type: .soso), .init(id: "2", text: "상관없어", type: .soso), .init(id: "3", text: "고기", type: .like), .init(id: "4", text: "해산물", type: .like), .init(id: "5", text: "쇼핑", type: .like), .init(id: "6", text: "산", type: .like), .init(id: "7", text: "바다", type: .like), .init(id: "8", text: "도시", type: .like), .init(id: "9", text: "핫 플레이스", type: .like), .init(id: "10", text: "민초 치킨", type: .dislike), .init(id: "11", text: "단팥크림빵", type: .dislike), .init(id: "12", text: "약", type: .dislike)]

        let sosoItems = tags.filter { $0.type == .soso }
        let sosoSection = TagSectionModel(model: .soso(sosoItems), items: sosoItems.map { .tagCell(.init(tag: $0)) })

        let likeItems = tags.filter { $0.type == .like }
        let likeSection = TagSectionModel(model: .like(likeItems), items: tags.filter { $0.type == .like }.map { .tagCell(.init(tag: $0)) })

        let dislikeItems = tags.filter { $0.type == .dislike }
        let dislikeSection = TagSectionModel(model: .dislike(dislikeItems), items: dislikeItems.map { .tagCell(.init(tag: $0)) })

        return [sosoSection, likeSection, dislikeSection]
    }
}
