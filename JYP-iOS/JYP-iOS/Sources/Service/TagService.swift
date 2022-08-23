//
//  TagService.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/13.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxSwift

enum TagServiceEvent {
    case save(Tag)
}

protocol TagServiceType {
    var event: PublishSubject<TagServiceEvent> { get }

    func saveTag(name: String, section: TagSection) -> Observable<Tag>
}

final class TagService: BaseService, TagServiceType {
    let event = PublishSubject<TagServiceEvent>()

    func saveTag(name: String, section: TagSection) -> Observable<Tag> {
        let tag = Tag(topic: name, orientation: section.type, users: [])

        event.onNext(.save(tag))
        return .just(tag)
    }
}
