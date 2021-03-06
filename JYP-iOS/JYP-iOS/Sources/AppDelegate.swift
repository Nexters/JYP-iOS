//
//  AppDelegate.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/12.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDK.initSDK(appKey: Environment.kakaoAppKey)
        GMSServices.provideAPIKey(Environment.googleAPIKey)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
}
