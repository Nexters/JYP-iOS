//
//  ServiceProviderType.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/09.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

protocol ServiceProviderType: AnyObject {
    var userService: UserServiceType { get }
    var kakaoSearchService: KakaoSearchServiceType { get }
    var tagService: TagServiceType { get }
    var journeyService: JourneyServiceType { get }
    var keychainService: KeychainServiceType { get }
    
    var onboaringService: OnboardingServiceProtocol { get }
    var plannerService: PlannerServiceProtocol { get }
}

final class ServiceProvider: ServiceProviderType {
    static let shared = ServiceProvider()
    
    lazy var userService: UserServiceType = UserService(provider: self)
    lazy var kakaoSearchService: KakaoSearchServiceType = KakaoSearchService(provider: self)
    lazy var tagService: TagServiceType = TagService(provider: self)
    lazy var journeyService: JourneyServiceType = JourneyService(provider: self)
    lazy var keychainService: KeychainServiceType = KeychainService(provider: self)
    
    lazy var onboaringService: OnboardingServiceProtocol = OnboardingService(provider: self)
    lazy var plannerService: PlannerServiceProtocol = PlannerService()
    
    private init() { }
}
