//
//  TabBarViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/17.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myPlannerNavigationViewController = UINavigationController(rootViewController: MyPlannerViewController())
        let myPlannerTabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        
        let myPageNavigationViewController = UINavigationController(rootViewController: MyPageViewController())
        let myPageTabBarItem = UITabBarItem(title: "마이", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person"))
        
        let searchPlannerNavigationViewController = UINavigationController(rootViewController: SearchPlannerViewController())
        let searchPlannerTabBarItem = UITabBarItem(title: "탐색", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        myPlannerNavigationViewController.tabBarItem = myPlannerTabBarItem
        myPageNavigationViewController.tabBarItem = myPageTabBarItem
        searchPlannerNavigationViewController.tabBarItem = searchPlannerTabBarItem
        
        self.viewControllers = [searchPlannerNavigationViewController, myPlannerNavigationViewController, myPageNavigationViewController]
        
        selectedIndex = 1
    }
}
