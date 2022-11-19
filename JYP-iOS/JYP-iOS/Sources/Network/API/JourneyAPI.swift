//
//  JourneyAPI.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/11/14.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import Moya

enum JourneyAPI {
    case fetchJourneys
    case fetchJourney
    case fetchDefaultTags
    case search(id: Int)
    case update(id: Int, request: UserUpdateRequest)
    case signup(request: SignupRequest)
}

extension JourneyAPI: BaseAPI {
    var baseURL: URL {
        URL(string: Environment.url)!
    }

    var path: String {
        switch self {
        case .fetchJourneys: return ""
        case .fetchJourney: return ""
        case .fetchDefaultTags: return ""
        case let .search(id): return "/users/\(id)"
        case let .update(id, _): return "/users/\(id)"
        case .signup: return "users"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchJourneys: return .get
        case .fetchJourney: return .get
        case .fetchDefaultTags: return .get
        case .search: return .get
        case .update: return .patch
        case .signup: return .post
        }
    }

    var task: Task {
        switch self {
        case .fetchJourneys: return .requestPlain
        case .fetchJourney: return .requestPlain
        case .fetchDefaultTags: return .requestPlain
        case .search: return .requestPlain
        case let .update(_, request): return .requestJSONEncodable(request)
        case let .signup(request):
            print(request)
            return .requestJSONEncodable(request)
        }
    }

    var headers: [String: String]? {
        [
            "jyp-jwt-master-key": Environment.jwtKey,
            "jyp-override-id": "1"
        ]
    }
}
