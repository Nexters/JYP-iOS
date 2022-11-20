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
    case fetchJourney(journeyId: String)
    case fetchDefaultTags
    case createJourney(request: CreateJourneyRequest)
    case fetchTags(journeyId: String)
    case updateTags(journeyId: String, request: UpdateTagsRequest)
    case createPikmi(journeyId: String, request: CreatePikmiRequest)
    case updatePikis(journeyId: String, request: UpdatePikisRequest)
    case createJourneyUser(journeyId: String, request: CreateJourneyUserRequest)
    case deleteJourneyUser(journeyId: String)
    case createPikmiLike(journeyId: String, pikmiId: String)
    case deletePikmiLike(journeyId: String, pikmiId: String)
}

extension JourneyAPI: BaseAPI {
    var baseURL: URL {
        URL(string: Environment.url + "/journeys")!
    }

    var path: String {
        switch self {
        case .fetchJourneys:
            return ""
            
        case .createJourney:
            return ""
            
        case .fetchDefaultTags:
            return "/default-tags"
            
        case let .fetchJourney(id):
            return "/\(id)"
            
        case let .fetchTags(id):
            return "/\(id)/tags"
            
        case let .updateTags(id, _):
            return "/\(id)/tags"
            
        case let .createPikmi(id, _):
            return "/\(id)/pikmis"
            
        case let .updatePikis(id, _):
            return "/\(id)/pikis"
            
        case let .createJourneyUser(id, _):
            return "/\(id)/join"

        case let .deleteJourneyUser(id):
            return "/\(id)/drop"
            
        case let .createPikmiLike(journeyId, pikmiId):
            return "/\(journeyId)/pikmis/\(pikmiId)/likes"
            
        case let .deletePikmiLike(journeyId, pikmiId):
            return "/journeys/\(journeyId)/pikmis/\(pikmiId)/unlikes"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchJourneys, .fetchDefaultTags, .fetchJourney, .fetchTags:
            return .get
            
        case .createJourney, .createPikmi, .createJourneyUser, .createPikmiLike, .updateTags, .updatePikis, .deleteJourneyUser, .deletePikmiLike:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .fetchJourneys, .fetchDefaultTags, .fetchJourney, .fetchTags, .deleteJourneyUser, .createPikmiLike, .deletePikmiLike:
            return .requestPlain
            
        case let .createJourney(request):
            return .requestJSONEncodable(request)
            
        case let .updateTags(_, request):
            return .requestJSONEncodable(request)
            
        case let .createPikmi(_, request):
            return .requestJSONEncodable(request)
            
        case let .updatePikis(_, request):
            return .requestJSONEncodable(request)
            
        case let .createJourneyUser(_, request):
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
