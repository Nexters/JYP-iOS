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

    static var kakaoAPI: String { "https://dapi.kakao.com" }
    static let kakaoRestKey = JYPIOSResources.bundle.infoDictionary?["KAKAO_REST_KEY"] ?? ""
    static let kakaoAppKey: String = JYPIOSResources.bundle.infoDictionary?["KAKAO_APP_KEY"] as? String ?? ""
    static let googleAPIKey: String = JYPIOSResources.bundle.infoDictionary?["GOOGLE_API_KEY"] as? String ?? ""
}
