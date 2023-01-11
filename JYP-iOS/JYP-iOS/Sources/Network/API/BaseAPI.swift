//
//  BaseAPI.swift
//  JYP-iOSTests
//
//  Created by inae Lee on 2022/07/21.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import Moya

protocol BaseAPI: TargetType {}

extension BaseAPI {
    var baseURL: URL {
        URL(string: Environment.url)!
    }

    var headers: [String: String]? {
        if let token = KeychainAccess.get(key: .accessToken) {
            return [
                "Authorization": "Bearer \(token)",
                "Content-Type": "application/json",
            ]
        } else {
            return nil
        }
    }

    var sampleData: Data {
        Data()
    }
}
