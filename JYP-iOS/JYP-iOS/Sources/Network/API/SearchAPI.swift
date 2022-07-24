//
//  SearchAPI.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/22.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import Moya

enum SearchAPI {
    case placeSearch(keyword: String, page: Int = 1)
}

extension SearchAPI: BaseAPI {
    var baseURL: URL {
        URL(string: Environment.kakaoAPI)!
    }

    var path: String {
        switch self {
        case .placeSearch: return "/v2/local/search/keyword.json"
        }
    }

    var method: Moya.Method {
        switch self {
        case .placeSearch: return .get
        }
    }

    var task: Task {
        switch self {
        case let .placeSearch(keyword, page):
            let requestParameters: [String: Any] = ["query": keyword, "page": page]

            return .requestParameters(parameters: requestParameters, encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        ["Authorization": "KakaoAK \(Environment.kakaoRestKey)"]
    }
}
