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
    case journeys
    case createJourney(request: CreateJourneyRequest)
    case defaultTags
    case journey(journeyId: String)
    case tags(journeyId: String)
    case editTags(journeyId: String, request: EditTagsRequest)
    case addPikmi(journeyId: String, request: AddPikmiRequest)
    case editPikis(journeyId: String, request: EditPikisRequest)
    case join(journeyId: String, request: JoinRequest)
    case drop(journeyId: String)
    case like(journeyId: String, pikmiId: String)
    case unlike(journeyId: String, pikmiId: String)
}

extension JourneyAPI: BaseAPI {
    var baseURL: URL {
        URL(string: Environment.url)!
    }

    var path: String {
        switch self {
        case .journeys:
            return "/journeys"
            
        case .createJourney:
            return "/journeys"
            
        case .defaultTags:
            return "/journeys/default-tags"
            
        case let .journey(id):
            return "/journeys/\(id)"
            
        case let .tags(id):
            return "/journeys/\(id)/tags"
            
        case let .editTags(id, _):
            return "/journeys/\(id)/tags"
            
        case let .addPikmi(id, _):
            return "/journeys/\(id)/pikmis"
            
        case let .editPikis(id, _):
            return "/journeys/\(id)/pikis"
            
        case let .join(id, _):
            return "/journeys/\(id)/join"

        case let .drop(id):
            return "/journeys/\(id)/drop"
            
        case let .like(journeyId, pikmiId):
            return "/journeys/\(journeyId)/pikmis/\(pikmiId)/likes"
            
        case let .unlike(journeyId, pikmiId):
            return "/journeys/\(journeyId)/pikmis/\(pikmiId)/unlikes"
        }
    }

    var method: Moya.Method {
        switch self {
        case .journeys:
            return .get
            
        case .createJourney:
            return .post
            
        case .defaultTags:
            return .get
            
        case .journey:
            return .get
            
        case .tags:
            return .get
            
        case .editTags:
            return .post
            
        case .addPikmi:
            return .post
            
        case .editPikis:
            return .post
            
        case .join:
            return .post
            
        case .drop:
            return .post
            
        case .like:
            return .post
            
        case .unlike:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .journeys:
            return .requestPlain
            
        case let .createJourney(request):
            return .requestJSONEncodable(request)
            
        case .defaultTags:
            return .requestPlain
            
        case .journey:
            return .requestPlain
            
        case .tags:
            return .requestPlain
            
        case let .editTags(_, request):
            return .requestJSONEncodable(request)
            
        case let .addPikmi(_, request):
            return .requestJSONEncodable(request)
            
        case let .editPikis(_, request):
            return .requestJSONEncodable(request)
            
        case let .join(_, request):
            return .requestJSONEncodable(request)
            
        case .drop:
            return .requestPlain
            
        case .like:
            return .requestPlain
            
        case .unlike:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        [
            "jyp-jwt-master-key": Environment.jwtKey,
            "jyp-override-id": "1"
        ]
    }
}
