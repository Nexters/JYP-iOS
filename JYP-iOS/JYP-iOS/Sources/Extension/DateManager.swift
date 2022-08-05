//
//  DateManager.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/03.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct DateManager {
    private static let dataFormatter = DateFormatter().then {
        $0.locale = .init(identifier: "ko_KR")
    }

    static func dateToString(format: String = "yy.MM.dd", date: Date) -> String {
        Self.dataFormatter.dateFormat = format

        return Self.dataFormatter.string(from: date)
    }

    static func stringToDate(format: String = "yy.MM.dd", date: String) -> Date {
        Self.dataFormatter.dateFormat = format

        return Self.dataFormatter.date(from: date) ?? Date()
    }
}
