//
//  CalendarService.swift
//  JYP-iOS
//
//  Created by Devsisters on 2022/08/02.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import RxSwift

enum CalendarEvent {
    case updateStartDate(Date)
    case updateEndDate(Date)
}

protocol CalendarServiceProtocol {
    var event: PublishSubject<CalendarEvent> { get }

    func updateStartDate(to date: Date) -> Observable<Date>
    func updateEndDate(to date: Date) -> Observable<Date>
    func calcJourneyDays() -> String
}

class CalendarService: CalendarServiceProtocol {
    let event = PublishSubject<CalendarEvent>()
    var startDate: Date?
    var endDate: Date?

    func updateStartDate(to date: Date) -> Observable<Date> {
        startDate = date
        event.onNext(.updateStartDate(date))

        return .just(date)
    }

    func updateEndDate(to date: Date) -> Observable<Date> {
        endDate = date
        event.onNext(.updateEndDate(date))
        return .just(date)
    }

    func calcJourneyDays() -> String {
        guard let startDate = startDate,
              let endDate = endDate,
              let days = DateManager.calcDays(from: startDate.timeIntervalSince1970, to: endDate)
        else { return "" }

        return "\(days)박 \(days + 1)일"
    }
}
