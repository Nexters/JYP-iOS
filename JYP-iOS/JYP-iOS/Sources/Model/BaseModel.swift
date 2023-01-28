//
//  BaseModel.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/24.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct BaseModel<T: Codable>: Codable {
    var code: String
    var data: T?
    var message: String
}

struct EmptyModel: Codable {
    var code: String
    var message: String
}
