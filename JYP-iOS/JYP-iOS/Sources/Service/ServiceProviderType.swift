//
//  ServiceProviderType.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/09.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

protocol ServiceProviderType: AnyObject {
    var kakaoSearchService: KakaoSearchServiceType { get }
    var tagService: TagServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
    lazy var kakaoSearchService: KakaoSearchServiceType = KakaoSearchService(provider: self)
    lazy var tagService: TagServiceType = TagService(provider: self)
}
