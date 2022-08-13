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
    func fetchJorney(id: Int) -> Observable<Journey>
    func create(name: String, startDate: Double, endDate: Double) -> Observable<Journey>
}

final class JourneyService: BaseService, JourneyServiceType {
    let event = PublishSubject<JourneyEvent>()
    
    func fetchJorney(id: Int) -> Observable<Journey> {
        return .just(Journey(id: "1",
                             member: [0, 1, 2, 3],
                             name: "강릉 여행기",
                             startDate: 123,
                             endDate: 123,
                             pikis: [0, 1, 2, 3],
                             tags: [.init(id: "1", text: "바다", type: .like), .init(id: "2", text: "해산물", type: .like), .init(id: "3", text: "산", type: .like), .init(id: "4", text: "핫 플레이스", type: .dislike), .init(id: "5", text: "도시", type: .dislike), .init(id: "6", text: "상관없어", type: .soso)],
                             candidatePlaces: [.init(id: "1", name: "테스트1", address: "강원 강릉시 난설헌로 131", category: .hospital, like: 1, lon: 123, lan: 123, url: "https://www.naver.com/"), .init(id: "1", name: "테스트2", address: "강원 강릉시 난설헌로 131", category: .hospital, like: 3, lon: 123, lan: 123, url: "https://www.naver.com/"), .init(id: "1", name: "테스트3", address: "강원 강릉시 난설헌로 131", category: .hospital, like: 4, lon: 123, lan: 123, url: "https://www.naver.com/"), .init(id: "1", name: "아르떼 뮤지엄", address: "강원 강릉시 난설헌로 131", category: .hospital, like: 7, lon: 123, lan: 123, url: "https://www.naver.com/"), .init(id: "1", name: "아르떼 뮤지엄", address: "강원 강릉시 난설헌로 131", category: .hospital, like: 8, lon: 123, lan: 123, url: "https://www.naver.com/"), .init(id: "1", name: "아르떼 뮤지엄", address: "강원 강릉시 난설헌로 131", category: .hospital, like: 10, lon: 123, lan: 123, url: "https://www.naver.com/")].sorted(by: { $0.like < $1.like }),
                             themeUrl: ""))
    }
    
    func fetchJornenies() -> Observable<[Journey]> {
        return .just([.init(id: "1", member: [0, 1, 2], name: "여행 테스트1", startDate: 123, endDate: 123, pikis: [0, 1, 2], tags: [], candidatePlaces: [.init(id: "1", name: "테스트 ", address: "dd", category: .bank, like: 2, lon: 123, lan: 123, url: "2")], themeUrl: "")]).delay(.seconds(1), scheduler: MainScheduler.instance)
    }
    
    func create(name: String, startDate: Double, endDate: Double) -> Observable<Journey> {
        return .just(.init(id: "1", member: [0, 1, 2], name: "여행 테스트1", startDate: 123, endDate: 123, pikis: [0, 1, 2], tags: [], candidatePlaces: [.init(id: "1", name: "테스트 ", address: "dd", category: .bank, like: 1, lon: 123, lan: 123, url: "2")], themeUrl: "")).delay(.seconds(1), scheduler: MainScheduler.instance)
    }
}
