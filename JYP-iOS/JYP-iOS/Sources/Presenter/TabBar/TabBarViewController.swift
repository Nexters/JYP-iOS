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
        
        let myPlannerViewController = MyPlannerViewController()
        let homeTabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        
        let myPageViewController = MyPageViewController()
        let myPageTabBarItem = UITabBarItem(title: "마이", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person"))
        
        let searchPlannerViewController = SearchPlannerViewController()
        let searchPlannerTabBarItem = UITabBarItem(title: "탐색", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        myPlannerViewController.tabBarItem = homeTabBarItem
        myPageViewController.tabBarItem = myPageTabBarItem
        searchPlannerViewController.tabBarItem = searchPlannerTabBarItem
        
        self.viewControllers = [searchPlannerViewController, myPlannerViewController ,myPageViewController]
        
        selectedIndex = 1
    }
}
