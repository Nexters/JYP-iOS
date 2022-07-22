//
//  APIService.swift
//  JYP-iOSTests
//
//  Created by inae Lee on 2022/07/20.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift

final class APIService {
    private static let provider = MoyaProvider<MultiTarget>()

    private init() {}

    static func request<T: TargetType>(target: T) -> Single<Response> {
        provider.rx.request(MultiTarget(target))
    }
}
