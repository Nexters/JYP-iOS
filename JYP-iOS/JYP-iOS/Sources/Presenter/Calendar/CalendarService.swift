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
}

protocol CalendarServiceProtocol {
    var event: PublishSubject<CalendarEvent> { get }

    func updateStartDate(to date: Date) -> Observable<Date>
}

class CalendarService: CalendarServiceProtocol {
    let event = PublishSubject<CalendarEvent>()

    func updateStartDate(to date: Date) -> Observable<Date> {
        event.onNext(.updateStartDate(date))
        return .just(date)
    }
}
