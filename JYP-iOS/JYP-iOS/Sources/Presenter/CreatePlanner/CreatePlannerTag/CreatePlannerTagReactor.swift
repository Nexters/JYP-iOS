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
    static let MAX_SELECTION_COUNT = 3

    enum Action {
        case fetchJourneyTags
        case selectTag(IndexPath)
        case didTapStartButton
        case successCreatePlanner(String)
    }

    enum Mutation {
        case setTags([Tag])
        case updateAllSections
        case insertIndexPath(IndexPath)
        case removeIndexPath(IndexPath)
        case insertSectionTagItem(IndexPath, TagItem)
        case updateSectionTagItem(IndexPath, [TagItem])
        case activeStartButton
        case pushPlannerView(String)
    }

    struct State {
        var journey: Journey
        var sections: [TagSectionModel]
        var nomatterItems: [TagItem] = []
        var likeItems: [TagItem] = []
        var dislikeItems: [TagItem] = []
        var selectedItems = Set<IndexPath>()
        var isEnabledStartButton: Bool = false
        var createdPlannerID: String?
    }

    let initialState: State
    let provider: ServiceProviderType

    init(provider: ServiceProviderType, journey: Journey) {
        self.provider = provider
        initialState = State(
            journey: journey,
            sections: CreatePlannerTagReactor.makeSections()
        )
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchJourneyTags:
            return .concat([
                provider.journeyService.fetchDefaultTags().map { .setTags($0) },
                .just(.updateAllSections)
            ])
        case let .selectTag(indexPath):
            let items = remakeSelectedTagItems(indexPath: indexPath)

            let updateTagItem: Observable<Mutation> = .just(.updateSectionTagItem(indexPath, items))
            let enableStartButton: Observable<Mutation> = .just(.activeStartButton)

            if currentState.selectedItems.contains(indexPath) {
                return .concat(
                    .just(.removeIndexPath(indexPath)),
                    updateTagItem,
                    enableStartButton
                )
            } else {
                guard currentState.selectedItems.count < Self.MAX_SELECTION_COUNT else { return .empty() }

                return .concat(
                    .just(.insertIndexPath(indexPath)),
                    updateTagItem,
                    enableStartButton
                )
            }
        case .didTapStartButton:
            return provider.journeyService
                .createJourney(journey: currentState.journey)
                .map { .pushPlannerView($0) }
        case let .successCreatePlanner(id):
            provider.journeyService.didFinishCreatePlanner(id)
            return .empty()
        }
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let tagEvent = provider.tagService.event.flatMap { event -> Observable<Mutation> in
            switch event {
            case let .save(tag):
                let section = tag.orientation.section
                let item = self.currentState.sections[section].items.count
                let indexPath = IndexPath(item: item, section: section)

                let reactor = JYPTagCollectionViewCellReactor(tag: tag)
                let tag = TagItem.tagCell(reactor)
                return .just(.insertSectionTagItem(indexPath, tag))
            }
        }

        return Observable.merge(mutation, tagEvent)
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState: State = state

        switch mutation {
        case let .setTags(tags):
            newState.nomatterItems = tags.filter { $0.orientation == .nomatter }
                .map { TagItem.tagCell(.init(tag: $0)) }
            newState.likeItems = tags.filter { $0.orientation == .like }
                .map { TagItem.tagCell(.init(tag: $0)) }
            newState.dislikeItems = tags.filter { $0.orientation == .dislike }
                .map { TagItem.tagCell(.init(tag: $0)) }
        case .updateAllSections:
            newState.sections[JYPTagType.nomatter.section].items = newState.nomatterItems
            newState.sections[JYPTagType.like.section].items = newState.likeItems
            newState.sections[JYPTagType.dislike.section].items = newState.dislikeItems
        case let .insertSectionTagItem(indexPath, tags):
            newState.sections[indexPath.section].items.append(tags)
        case let .updateSectionTagItem(indexPath, tags):
            newState.sections[indexPath.section].items = tags
        case let .insertIndexPath(indexPath):
            newState.selectedItems.insert(indexPath)
            if case let TagItem.tagCell(tag) = state.sections[indexPath.section].items[indexPath.row] {
                newState.journey.tags.append(tag.currentState)
            }
        case let .removeIndexPath(indexPath):
            newState.selectedItems.remove(indexPath)
            if case let TagItem.tagCell(tag) = state.sections[indexPath.section].items[indexPath.row],
               let index = newState.journey.tags.firstIndex(where: { $0 == tag.currentState }) {
                newState.journey.tags.remove(at: index)
            }
        case .activeStartButton:
            newState.isEnabledStartButton = !currentState.selectedItems.isEmpty
        case let .pushPlannerView(id):
            newState.createdPlannerID = id
        }

        return newState
    }
}

extension CreatePlannerTagReactor {
    static func makeSections() -> [TagSectionModel] {
        let tags: [Tag] = [
            .init(topic: "모두 찬성", orientation: .nomatter, users: []),
            .init(topic: "상관없어", orientation: .nomatter, users: []),
            .init(topic: "고기", orientation: .like, users: []),
            .init(topic: "해산물", orientation: .like, users: []),
            .init(topic: "쇼핑", orientation: .like, users: []),
            .init(topic: "산", orientation: .like, users: []),
            .init(topic: "바다", orientation: .like, users: []),
            .init(topic: "도시", orientation: .like, users: []),
            .init(topic: "핫 플레이스", orientation: .like, users: []),
            .init(topic: "민초 치킨", orientation: .dislike, users: []),
            .init(topic: "단팥크림빵", orientation: .dislike, users: []),
            .init(topic: "약", orientation: .dislike, users: [])
        ]

        let nomatterItems = tags.filter { $0.orientation == .nomatter }
        let nomatterSection = TagSectionModel(
            model: .nomatter(nomatterItems),
            items: nomatterItems.map { .tagCell(.init(tag: $0)) }
        )

        let likeItems = tags.filter { $0.orientation == .like }
        let likeSection = TagSectionModel(
            model: .like(likeItems),
            items: tags.filter { $0.orientation == .like }.map { .tagCell(.init(tag: $0)) }
        )

        let dislikeItems = tags.filter { $0.orientation == .dislike }
        let dislikeSection = TagSectionModel(
            model: .dislike(dislikeItems),
            items: dislikeItems.map { .tagCell(.init(tag: $0)) }
        )

        return [nomatterSection, likeSection, dislikeSection]
    }
}

extension CreatePlannerTagReactor {
    /// 선택된 tag의 isSelected를 변경하고, items 배열의 원래 요소와 교체함
    /// - Parameter indexPath: 선택된 tag의 indexPath
    /// - Returns: 선택된 태그의 상태가 반영된 전체 Item 배열
    private func remakeSelectedTagItems(indexPath: IndexPath) -> [TagItem] {
        /// current Tag -> isSelecte toggle -> new Tag -> items 배열 replace
        var items = currentState.sections[indexPath.section].items
        let currentTag = items[indexPath.row]

        guard case let TagItem.tagCell(reactor) = currentTag else { return .init() }
        var newTag = reactor.currentState
        newTag.isSelected.toggle()

        items.replaceSubrange(indexPath.row ... indexPath.row, with: [.tagCell(JYPTagCollectionViewCellReactor(tag: newTag))])

        return items
    }
}
