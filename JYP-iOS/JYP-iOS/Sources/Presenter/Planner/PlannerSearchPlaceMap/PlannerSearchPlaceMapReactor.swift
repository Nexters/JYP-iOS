//
//  PlannerSearchPlaceMapReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/14.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit

class PlannerSearchPlaceMapReactor: Reactor {
    enum Action {
        case tapInfoButton
        case tapAddButton
    }
    
    enum Mutation {
        case setWebReactor(WebReactor?)
    }
    
    struct State {
        let id: String
        let kakaoSearchPlace: KakaoSearchPlace
        var webReactor: WebReactor?
    }
    
    let provider = ServiceProvider.shared
    var initialState: State
    
    init(id: String, kakaoSearchPlace: KakaoSearchPlace) {
        self.initialState = State(id: id, kakaoSearchPlace: kakaoSearchPlace)
    }
}

extension PlannerSearchPlaceMapReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapInfoButton:
            return .concat([
                .just(.setWebReactor(WebReactor(state: .init(url: currentState.kakaoSearchPlace.placeURL)))),
                .just(.setWebReactor(nil))
            ])
            
        case .tapAddButton:
            createPikmi()
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setWebReactor(reactor):
            newState.webReactor = reactor
        }
        
        return newState
    }
    
    private func createPikmi() {
        let id = currentState.id
        let name = currentState.kakaoSearchPlace.placeName
        let address = currentState.kakaoSearchPlace.addressName
        let category = JYPCategoryType.getJYPCategoryType(categoryGroupCode: currentState.kakaoSearchPlace.categoryGroupCode)
        let longitude = Double(currentState.kakaoSearchPlace.x) ?? 0.0
        let latitude = Double(currentState.kakaoSearchPlace.y) ?? 0.0
        let link = currentState.kakaoSearchPlace.placeURL
        
        provider.journeyService.createPikmi(id: id, name: name, address: address, category: category, longitude: longitude, latitude: latitude, link: link)
    }
}
