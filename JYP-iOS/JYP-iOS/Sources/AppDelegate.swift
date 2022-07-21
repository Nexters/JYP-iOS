//
//  AppDelegate.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/12.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("1")
        // Override point for customization after application launch.
//        window = UIWindow(frame: UIScreen.main.bounds)
        // FIXME: 카카오 SDK 설정
//        KakaoSDK.initSDK(appKey: "여기다가 앱키!!")
//        let mainViewController = TabBarViewController()
//
//        window?.rootViewController = mainViewController
//        window?.makeKeyAndVisible()
//
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }
}
