//
//  TagSectionModel.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/09.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias TagSectionModel = SectionModel<TagSection, TagItem>

enum TagSection: Equatable {
    case soso([Tag])
    case like([Tag])
    case dislike([Tag])
}

extension TagSection {
    var items: [Tag] {
        switch self {
        case let .soso(tags):
            return tags
        case let .like(tags):
            return tags
        case let .dislike(tags):
            return tags
        }
    }

    init(original: TagSection, tags: [Tag]) {
        switch original {
        case .soso:
            self = .soso(tags)
        case .like:
            self = .like(tags)
        case .dislike:
            self = .dislike(tags)
        }
    }
}

enum TagItem: Equatable {
    case tagCell(Tag)
}
