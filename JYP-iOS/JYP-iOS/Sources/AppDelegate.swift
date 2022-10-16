//
//  AppDelegate.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/12.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
#if targetEnvironment(simulator)
#else
    import GoogleMaps
#endif

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDK.initSDK(appKey: Environment.kakaoAppKey)
        #if targetEnvironment(simulator)
        #else
            GMSServices.provideAPIKey(Environment.googleAPIKey)
        #endif
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
}
