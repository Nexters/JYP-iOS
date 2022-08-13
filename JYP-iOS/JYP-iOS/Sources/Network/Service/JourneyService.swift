//
//  JourneyService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/13.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxSwift

enum JourneyEvent {
    case create(Journey)
}

protocol JourneyServiceType {
    var event: PublishSubject<JourneyEvent> { get }
    
    func fetchJornenies() -> Observable<[Journey]>
    func create(name: String, startDate: Double, endDate: Double) -> Observable<Journey>
}

final class JourneyService: BaseService, JourneyServiceType {
    let event = PublishSubject<JourneyEvent>()
    
    func fetchJornenies() -> Observable<[Journey]> {
        return .just([.init(id: "1", member: [0, 1, 2], name: "여행 테스트1", startDate: 123, endDate: 123, pikis: [0, 1, 2], candidatePlaces: [.init(id: "1", name: "테스트 ", address: "dd", category: .bank, like: 2, lon: 123, lan: 123, url: "2")], themeUrl: "")]).delay(.seconds(1), scheduler: MainScheduler.instance)
    }
    
    func create(name: String, startDate: Double, endDate: Double) -> Observable<Journey> {
        return .just(.init(id: "1", member: [0, 1, 2], name: "여행 테스트1", startDate: 123, endDate: 123, pikis: [0, 1, 2], candidatePlaces: [.init(id: "1", name: "테스트 ", address: "dd", category: .bank, like: 1, lon: 123, lan: 123, url: "2")], themeUrl: "")).delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}
