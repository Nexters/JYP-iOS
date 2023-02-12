//
//  PlannerSearchPlaceMapReactor.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/14.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

class PlannerSearchPlaceMapReactor: Reactor {
    enum Action {
        case tapInfoButton
        case tapAddButton
    }
    
    enum Mutation {
        case setWebReactor(WebReactor?)
        case setIsBack(Bool)
    }
    
    struct State {
        let id: String
        let kakaoSearchPlace: KakaoSearchPlace
        var webReactor: WebReactor?
        var isBack: Bool = false
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
                .just(.setWebReactor(WebReactor(url: currentState.kakaoSearchPlace.placeURL))),
                .just(.setWebReactor(nil))
            ])
            
        case .tapAddButton:
            createPikmi()
            return .empty()
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let APIMutation = provider.journeyService.event.withUnretained(self).flatMap { (this, event) -> Observable<Mutation> in
            switch event {
            case .createPikmi:
                return .concat([
                    .just(.setIsBack(true)),
                    .just(.setIsBack(false))
                ])
                
            default:
                return .empty()
            }
        }

        return Observable.merge(mutation, APIMutation)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setWebReactor(reactor):
            newState.webReactor = reactor
            
        case let .setIsBack(bool):
            newState.isBack = bool
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
