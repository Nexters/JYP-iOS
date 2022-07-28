//
//  Array+Ext.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/26.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

extension Array {
    func indexExists(_ index: Int) -> Bool {
        return self.indices.contains(index)
    }
}
