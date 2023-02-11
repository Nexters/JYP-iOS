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
    case fetchMe
    case fetchUser(id: String)
    case updateUser(id: String, request: UpdateUserRequest)
    case createUser(request: CreateUserRequest)
    case deleteUser(id: String)
}

extension UserAPI: BaseAPI {
    var baseURL: URL {
        URL(string: Environment.url)!
    }

    var path: String {
        switch self {
        case .fetchMe:
            return "users/me"
            
        case let .fetchUser(id):
            return "users/\(id)"
            
        case let .updateUser(id, _):
            return "users/\(id)"
            
        case .createUser:
            return "users"
            
        case let .deleteUser(id):
            return "users/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .fetchMe:
            return .get
            
        case .fetchUser:
            return .get
            
        case .updateUser:
            return .patch
            
        case .createUser:
            return .post
            
        case .deleteUser:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .fetchMe, .fetchUser, .deleteUser:
            return .requestPlain
            
        case let .updateUser(_, request):
            return .requestJSONEncodable(request)
            
        case let .createUser(request):
            return .requestJSONEncodable(request)
        }
    }
}
