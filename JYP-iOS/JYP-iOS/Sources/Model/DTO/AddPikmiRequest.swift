//
//  AddPikmiRequest.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/11/19.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct AddPikmiRequest: Codable {
    let name, address, category: String
    let longitude, latitude: Int
    let link: String
}
