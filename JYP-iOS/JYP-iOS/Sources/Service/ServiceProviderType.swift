//
//  ServiceProviderType.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/09.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

protocol ServiceProviderType: class {
    var kakaoSearchService: KakaoSearchServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
    lazy var kakaoSearchService: KakaoSearchServiceType = KakaoSearchService(provider: self)
}
