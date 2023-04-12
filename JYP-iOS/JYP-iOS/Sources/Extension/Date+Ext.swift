//
//  Date+Ext.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/04/12.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import Foundation

extension Date {
    public static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    
    public func isDate(inSameDayAs date: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: date)
    }
    
    public func isDate(start date1: Date, end date2: Date) -> Bool {
        return Date.dates(from: min(date1, date2), to: max(date1, date2)).contains(where: { $0.isDate(inSameDayAs: self) })
    }
}
