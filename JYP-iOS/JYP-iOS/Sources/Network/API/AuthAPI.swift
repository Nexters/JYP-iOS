//
//  AuthAPI.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/01/10.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import Foundation
import Moya

enum AuthAPI {
    case apple(token: String)
    case kakao(token: String)
}

extension AuthAPI: BaseAPI {
    var baseURL: URL {
        URL(string: Environment.url + "/auth")!
    }
    
    var path: String {
        switch self {
        case .apple:
            return "apple/login"
            
        case .kakao:
            return "kakao/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .apple, .kakao:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .apple, .kakao:
            return .requestPlain
        }
        
    }
    
    var headers: [String : String]? {
        switch self {
        case let .apple(token):
            return [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
            ]
            
        case let .kakao(token):
            return [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
            ]
        }
    }
}
