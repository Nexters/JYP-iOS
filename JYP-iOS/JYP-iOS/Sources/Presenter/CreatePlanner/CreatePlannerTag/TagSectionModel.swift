//
//  TagSectionModel.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/09.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxDataSources

typealias TagSectionModel = SectionModel<TagSection, TagItem>

enum TagSection: Codable {
    case nomatter([Tag])
    case like([Tag])
    case dislike([Tag])
}

extension TagSection {
    var title: String {
        switch self {
        case .nomatter: return "상관없어요 태그"
        case .like: return "좋아요 태그"
        case .dislike: return "싫어요 태그"
        }
    }
    
    var type: JYPTagType {
        switch self {
        case .nomatter: return .nomatter
        case .like: return .like
        case .dislike: return .dislike
        }
    }

    var isHiddenRightButton: Bool {
        switch self {
        case .nomatter: return true
        case .like, .dislike: return false
        }
    }

    init(original: TagSection, tags: [Tag]) {
        switch original {
        case .nomatter:
            self = .nomatter(tags)
        case .like:
            self = .like(tags)
        case .dislike:
            self = .dislike(tags)
        }
    }
}

enum TagItem {
    case tagCell(JYPTagCollectionViewCellReactor)
}
