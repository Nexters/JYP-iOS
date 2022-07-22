//
//  NetworkLoggerPlugin.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/22.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import Moya

final class NetworkLoggerPlugin: PluginType {
    func willSend(_ request: RequestType, target _: TargetType) {
        guard let request = request.request, let method = request.method else {
            print("Invalid Request")
            return
        }
        print("==============[willSend]==============")
        print("[Logger - ✅ Header] \(request.headers)")
        print("[Logger - ✅ Endpoint] [\(method.rawValue)] - \(String(describing: request.url))")
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        print("==============[didReceive]==============")
        print("[Logger - ✅ request] \(target.baseURL)/\(target.path)")

        switch result {
        case let .success(response):
            print("[Logger - ✅ result] ⭕️ SUCCESS")
            guard let json = try? response.mapJSON() else { return }
            print(json)
        case let .failure(error):
            print("[Logger - ✅ result] ❌ FAILURE")
            print(error)
        }
    }
}
