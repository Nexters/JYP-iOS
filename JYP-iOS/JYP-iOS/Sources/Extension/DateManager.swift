//
//  DateManager.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/03.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

struct DateManager {
    static var currentTimeInterval: TimeInterval {
        Date().timeIntervalSince1970
    }

    private static let dataFormatter = DateFormatter().then {
        $0.locale = .init(identifier: "ko_KR")
    }

    static func doubleToDateString(format: String = "yy.MM.dd", double: Double) -> String {
        let timeInterval = TimeInterval(floatLiteral: double)
        let convertedDate = Date(timeIntervalSince1970: timeInterval)

        return Self.dateToString(format: format, date: convertedDate)
    }

    static func dateToString(format: String = "yy.MM.dd", date: Date) -> String {
        Self.dataFormatter.dateFormat = format

        return Self.dataFormatter.string(from: date)
    }

    static func stringToDate(format: String = "yy.MM.dd", date: String) -> Date {
        Self.dataFormatter.dateFormat = format

        return Self.dataFormatter.date(from: date) ?? Date()
    }

    static func addDateComponent(byAdding: Calendar.Component, value: Int, to: Date) -> Date {
        Calendar.current.date(byAdding: byAdding, value: value, to: to) ?? to
    }

    /// 입력받은 timeInterval로 부터 남은 날짜를 계산한다
    /// - Parameter timeInterval: 계산하고자 하는 날짜의 timeInterval
    /// - Returns: 남은 날짜 (D-Day)를 반환한다
    static func calcDays(from timeInterval: Double) -> Int? {
        let calendar = Calendar.current
        guard let date = calendar.dateComponents(
            [.day],
            from: calendar.startOfDay(for: Date(timeIntervalSince1970: timeInterval)),
            to: calendar.startOfDay(for: Date())
        ).day
        else { return nil }

        return date
    }
}
