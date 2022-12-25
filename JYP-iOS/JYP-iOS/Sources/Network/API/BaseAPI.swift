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
        [
            "Authorization": "Bearer \(Environment.accessToken)",
            "Content-Type": "application/json",
        ]
    }

    var sampleData: Data {
        Data()
    }
}
