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
                                 nickname: "닉네임안녕나는",
                                 profileImagePath: "",
                                 personalityID: .ME),
                            User(id: "2", nickname: "닉네임하나하나", profileImagePath: "", personalityID: .ME),
                            User(id: "3", nickname: "닉네임안녕피피", profileImagePath: "", personalityID: .PE)],
                    tags: [Tag(topic: "태그1", orientation: .like, users: [User(id: "1",
                                                                              nickname: "닉네임안녕나는안",
                                                                              profileImagePath: "https://static.wikia.nocookie.net/pokemon/images/0/0f/%EB%AC%BC%EC%A7%B1%EC%9D%B4_%EA%B3%B5%EC%8B%9D_%EC%9D%BC%EB%9F%AC%EC%8A%A4%ED%8A%B8.png/revision/latest?cb=20170412111617&path-prefix=ko",
                                                                              personalityID: .ME),
                                                                         User(id: "2", nickname: "닉네임테스트야ㅕ", profileImagePath: "https://mblogthumb-phinf.pstatic.net/20160605_113/qkrtnaud11_1465100243458mw28P_PNG/393Piplup.png?type=w2", personalityID: .ME),
                                                                         User(id: "3", nickname: "닉네임하하어어", profileImagePath: "https://mblogthumb-phinf.pstatic.net/MjAxOTA3MTFfMjM0/MDAxNTYyODM4MDczMzg3.no6xmpenNPkIL9nb9wSOTkVTlRcTHN7OVZPZI8bMPnwg.n7RJ1J_AF7GAhl7msTqgYm9hfNFRhvoOw6-j4b_WKLgg.JPEG.saehongburn4/%EB%AC%BC%EC%A7%B1%EC%9D%B4_%EA%B3%B5%EC%8B%9D_%EC%9D%BC%EB%9F%AC%EC%8A%A4%ED%8A%B8.jpg?type=w800", personalityID: .PE)])],
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
