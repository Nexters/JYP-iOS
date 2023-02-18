//
//  Environment.swift
//  JYP-iOSTests
//
//  Created by inae Lee on 2022/07/21.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct Environment {
    static var url: String {
        JYPIOSResources.bundle.infoDictionary?["SERVER_HOST"] as? String ?? ""
    }
    static var version: String {
        JYPIOSResources.bundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    static let jwtKey: String = JYPIOSResources.bundle.infoDictionary?["SERVER_JWT_MASTER_KEY"] as? String ?? ""
    static var kakaoAPI: String { "https://dapi.kakao.com" }
    static let kakaoRestKey = JYPIOSResources.bundle.infoDictionary?["KAKAO_REST_KEY"] ?? ""
    static let kakaoAppKey: String = JYPIOSResources.bundle.infoDictionary?["KAKAO_APP_KEY"] as? String ?? ""
    static let googleAPIKey: String = JYPIOSResources.bundle.infoDictionary?["GOOGLE_API_KEY"] as? String ?? ""
    static let manualUrl: String = "https://plausible-seahorse-ba5.notion.site/Journey-piki-688aac1424924a30bf974c7866592a98"
}
