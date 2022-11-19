//
//  UserAPI.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/21.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import Moya

enum UserAPI {
    case user(id: String)
    case editUser(id: String, request: EditUserRequest)
    case createUser(request: CreateUserRequest)
}

extension UserAPI: BaseAPI {
    var baseURL: URL {
        URL(string: Environment.url)!
    }

    var path: String {
        switch self {
        case let .user(id):
            return "/users/\(id)"
            
        case let .editUser(id, _):
            return "/users/\(id)"
            
        case .createUser: return "users"
        }
    }

    var method: Moya.Method {
        switch self {
        case .user: return .get
            
        case .editUser: return .patch
            
        case .createUser: return .post
        }
    }

    var task: Task {
        switch self {
        case .user:
            return .requestPlain
            
        case let .editUser(_, request):
            return .requestJSONEncodable(request)
            
        case let .createUser(request):
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
