//
//  UserDefaultsAccess.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/01/27.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import Foundation

enum UserDefaultsAccessKey: String {
    case userID
    case nickname
    case profileImagePath
    case personality
}

final class UserDefaultsAccess {
    static var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    static func set(key: UserDefaultsAccessKey, value: String) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    static func get(key: UserDefaultsAccessKey) -> String? {
        return userDefaults.object(forKey: key.rawValue) as? String
    }
    
    static func remove(key: UserDefaultsAccessKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
