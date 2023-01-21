//
//  KeychainService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/11/24.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

import KeychainAccess

enum KeychainKey {
    static let authVendor = "authVendor"
    static let accessToken = "accessToken"
    static let name = "name"
    static let imagePath = "imagePath"
}

protocol KeychainServiceType: AnyObject {
    func getAuthVendor() -> AuthVendor?
    func getAccessToken() -> String?
    func getName() -> String?
    func getImagePath() -> String?
    
    func setAuthVendor(_ vendor: AuthVendor) throws
    func setAccessToken(_ token: String) throws
    func setName(_ name: String) throws
    func setImagePath(_ path: String) throws
    
    func removeAccessToken() throws
    func removeAuthVendor() throws
    func removeName() throws
    func removeImagePath() throws
}

final class KeychainService: GlobalService, KeychainServiceType {
    private var keychain: Keychain {
        return Keychain(service: "jyp.journeypiki")
    }
    
    func getAccessToken() -> String? {
        guard let token = self.keychain[KeychainKey.accessToken] else {
            return nil
        }
        return token
    }
    
    func getAuthVendor() -> AuthVendor? {
        guard let vendor = self.keychain[KeychainKey.authVendor] else {
            return nil
        }
        return AuthVendor(rawValue: vendor)
    }
    
    func getName() -> String? {
        guard let name = self.keychain[KeychainKey.name] else {
            return nil
        }
        return name
    }
    
    func getImagePath() -> String? {
        guard let path = self.keychain[KeychainKey.imagePath] else {
            return nil
        }
        return path
    }
    
    func setAccessToken(_ token: String) throws {
        try self.keychain.set(token, key: KeychainKey.accessToken)
    }
    
    func setAuthVendor(_ vendor: AuthVendor) throws {
        try self.keychain.set(vendor.rawValue, key: KeychainKey.authVendor)
    }
    
    func setName(_ name: String) throws {
        try self.keychain.set(name, key: KeychainKey.name)
    }
    
    func setImagePath(_ path: String) throws {
        try self.keychain.set(path, key: KeychainKey.imagePath)
    }
    
    func removeAccessToken() throws {
        try self.keychain.remove(KeychainKey.accessToken)
    }
    
    func removeAuthVendor() throws {
        try self.keychain.remove(KeychainKey.authVendor)
    }
    
    func removeName() throws {
        try self.keychain.remove(KeychainKey.name)
    }
    
    func removeImagePath() throws {
        try self.keychain.remove(KeychainKey.imagePath)
    }
}
