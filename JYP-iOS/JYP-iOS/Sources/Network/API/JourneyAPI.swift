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
    case editTags(journeyId: String, request: EditTagsRequest)
    case addPikmi(journeyId: String, request: AddPikmiRequest)
    case editPikis(journeyId: String, request: EditPikisRequest)
    case addJourneyUser(journeyId: String, request: AddJourneyUserRequest)
    case deleteJourneyUser(journeyId: String)
    case addPikmiLike(journeyId: String, pikmiId: String)
    case deletePikmiLike(journeyId: String, pikmiId: String)
}

extension JourneyAPI: BaseAPI {
    var baseURL: URL {
        URL(string: Environment.url)!
    }

    var path: String {
        switch self {
        case .fetchJourneys:
            return "/journeys"
            
        case .createJourney:
            return "/journeys"
            
        case .fetchDefaultTags:
            return "/journeys/default-tags"
            
        case let .fetchJourney(id):
            return "/journeys/\(id)"
            
        case let .fetchTags(id):
            return "/journeys/\(id)/tags"
            
        case let .editTags(id, _):
            return "/journeys/\(id)/tags"
            
        case let .addPikmi(id, _):
            return "/journeys/\(id)/pikmis"
            
        case let .editPikis(id, _):
            return "/journeys/\(id)/pikis"
            
        case let .addJourneyUser(id, _):
            return "/journeys/\(id)/join"

        case let .deleteJourneyUser(id):
            return "/journeys/\(id)/drop"
            
        case let .addPikmiLike(journeyId, pikmiId):
            return "/journeys/\(journeyId)/pikmis/\(pikmiId)/likes"
            
        case let .deletePikmiLike(journeyId, pikmiId):
            return "/journeys/\(journeyId)/pikmis/\(pikmiId)/unlikes"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchJourneys:
            return .get
            
        case .createJourney:
            return .post
            
        case .fetchDefaultTags:
            return .get
            
        case .fetchJourney:
            return .get
            
        case .fetchTags:
            return .get
            
        case .editTags:
            return .post
            
        case .addPikmi:
            return .post
            
        case .editPikis:
            return .post
            
        case .addJourneyUser:
            return .post
            
        case .deleteJourneyUser:
            return .post
            
        case .addPikmiLike:
            return .post
            
        case .deletePikmiLike:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .fetchJourneys:
            return .requestPlain
            
        case let .createJourney(request):
            return .requestJSONEncodable(request)
            
        case .fetchDefaultTags:
            return .requestPlain
            
        case .fetchJourney:
            return .requestPlain
            
        case .fetchTags:
            return .requestPlain
            
        case let .editTags(_, request):
            return .requestJSONEncodable(request)
            
        case let .addPikmi(_, request):
            return .requestJSONEncodable(request)
            
        case let .editPikis(_, request):
            return .requestJSONEncodable(request)
            
        case let .addJourneyUser(_, request):
            return .requestJSONEncodable(request)
            
        case .deleteJourneyUser:
            return .requestPlain
            
        case .addPikmiLike:
            return .requestPlain
            
        case .deletePikmiLike:
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
