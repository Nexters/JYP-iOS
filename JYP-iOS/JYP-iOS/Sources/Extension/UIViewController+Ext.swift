//
//  UIViewController+Ext.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/01/10.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import UIKit

extension UIViewController {
    func navigationWrap() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
