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
    
    func fetchJornenies() -> Observable<[Journey]> {
        return .just(
            [Journey(id: "1",
                     name: "",
                     startDate: 0,
                     endDate: 0,
                     themePath: .city,
                     users: [],
                     tags: nil,
                     pikis: nil,
                     pikmis: nil),
             Journey(id: "1",
                     name: "",
                     startDate: 0,
                     endDate: 0,
                     themePath: .culture,
                     users: [],
                     tags: nil,
                     pikis: nil,
                     pikmis: nil),
             Journey(id: "1",
                     name: "",
                     startDate: 0,
                     endDate: 0,
                     themePath: .mountain,
                     users: [],
                     tags: nil,
                     pikis: nil,
                     pikmis: nil)
            ]
        )
    }
    
    func fetchJorney(id: Int) -> Observable<Journey> {
        return .just(
            Journey(id: "1",
                    name: "테스트1",
                    startDate: 1662181200,
                    endDate: 1662699600,
                    themePath: .city,
                    users: [User(id: "1",
                                 nickname: "닉네임1",
                                 profileImagePath: "",
                                 personality: ""),
                            User(id: "2", nickname: "닉네임2", profileImagePath: "", personality: ""),
                            User(id: "3", nickname: "닉네임3", profileImagePath: "", personality: "")],
                    tags: [Tag(topic: "태그1", orientation: .like, users: [])],
                    pikis: [[Pik(id: "1",
                                 name: "피키1",
                                 address: "피키1 주소",
                                 category: .cafe,
                                 likeBy: nil,
                                 longitude: 0.0,
                                 latitude: 0.0,
                                 link: ""),
                             Pik(id: "1",
                                 name: "피키1",
                                 address: "피키1 주소",
                                 category: .cafe,
                                 likeBy: nil,
                                 longitude: 0.0,
                                 latitude: 0.0,
                                 link: ""),
                             Pik(id: "1",
                                 name: "피키1",
                                 address: "피키1 주소",
                                 category: .cafe,
                                 likeBy: nil,
                                 longitude: 0.0,
                                 latitude: 0.0,
                                 link: "")],
                            [],
                            [],
                            [],
                            [],
                            [],
                            [],
                            [],
                            []
                           ],
                    pikmis: []
//                    pikmis: [Pik(id: "1",
//                                 name: "픽미1",
//                                 address: "주소1",
//                                 category: .bank,
//                                 likeBy: [User(id: "1",
//                                               nickname: "닉네임1",
//                                               profileImagePath: "",
//                                               personality: ""),
//                                          User(id: "2", nickname: "닉네임2", profileImagePath: "", personality: ""),
//                                          User(id: "3", nickname: "닉네임3", profileImagePath: "", personality: "")], longitude: 0.0, latitude: 0.0, link: ""),
//                             Pik(id: "1",
//                                 name: "픽미2",
//                                 address: "주소2",
//                                 category: .bank,
//                                 likeBy: [User(id: "1",
//                                               nickname: "닉네임1",
//                                               profileImagePath: "",
//                                               personality: ""),
//                                          User(id: "2", nickname: "닉네임2", profileImagePath: "", personality: ""),
//                                          User(id: "3", nickname: "닉네임3", profileImagePath: "", personality: "")], longitude: 0.0, latitude: 0.0, link: ""),
//                             Pik(id: "1",
//                                 name: "픽미3",
//                                 address: "주소3",
//                                 category: .bank,
//                                 likeBy: [User(id: "1",
//                                               nickname: "닉네임1",
//                                               profileImagePath: "",
//                                               personality: ""),
//                                          User(id: "2", nickname: "닉네임2", profileImagePath: "", personality: ""),
//                                          User(id: "3", nickname: "닉네임3", profileImagePath: "", personality: "")], longitude: 0.0, latitude: 0.0, link: ""),
//                             Pik(id: "1",
//                                 name: "픽미4",
//                                 address: "주소4",
//                                 category: .bank,
//                                 likeBy: [User(id: "1",
//                                               nickname: "닉네임1",
//                                               profileImagePath: "",
//                                               personality: ""),
//                                          User(id: "2", nickname: "닉네임2", profileImagePath: "", personality: ""),
//                                          User(id: "3", nickname: "닉네임3", profileImagePath: "", personality: "")], longitude: 0.0, latitude: 0.0, link: ""),
//                             Pik(id: "1",
//                                 name: "픽미5",
//                                 address: "주소5",
//                                 category: .bank,
//                                 likeBy: [
//                                    User(id: "1",
//                                         nickname: "닉네임1",
//                                         profileImagePath: "",
//                                         personality: ""),
//                                    User(id: "2", nickname: "닉네임2", profileImagePath: "", personality: ""),
//                                    User(id: "3", nickname: "닉네임3", profileImagePath: "", personality: "")], longitude: 0.0, latitude: 0.0, link: "")
//                            ]
                   )
        )
    }
    
    func create(name: String, startDate: Double, endDate: Double) -> Observable<Journey> {
        return .just(Journey(id: "1",
                             name: "",
                             startDate: 0,
                             endDate: 0,
                             themePath: .culture,
                             users: [],
                             tags: nil,
                             pikis: nil,
                             pikmis: nil))
    }
}
