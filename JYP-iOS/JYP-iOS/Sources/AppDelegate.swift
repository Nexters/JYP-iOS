//
//  AppDelegate.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainViewController = TabBarViewController()
        
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

