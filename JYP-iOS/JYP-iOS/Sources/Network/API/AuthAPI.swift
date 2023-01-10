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
    case apple
    case kakao
}

extension AuthAPI: BaseAPI {
    var baseURL: URL {
        URL(string: Environment.url + "/auth")!
    }
    
    var path: String {
        switch self {
        case .apple:
            return "/apple/login"
            
        case .kakao:
            return "/kakao/login"
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
}
