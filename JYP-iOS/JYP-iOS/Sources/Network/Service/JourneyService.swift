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
    
    func fetchJornenys() -> Observable<BaseModel<FetchJourneysResponse>>
    func fetchJorney(journeyId: String) -> Observable<BaseModel<Journey>>
    func fetchDefaultTags() -> Observable<BaseModel<FetchTagsResponse>>
    func createJourney(request: CreateJourneyRequest) -> Observable<BaseModel<CreateJourneyResponse>>
    func editTags(journeyId: String, request: UpdateTagsRequest) -> Observable<EmptyModel>
    func addJourneyUser(journeyId: String, request: CreateJourneyUserRequest) -> Observable<EmptyModel>
    func deleteJourneyUser(journeyId: String) -> Observable<EmptyModel>
    func addPikmiLike(journeyId: String, pikmiId: String) -> Observable<EmptyModel>
    func deletePikmiLike(journeyId: String, pikmiId: String) -> Observable<EmptyModel>
}

final class JourneyService: BaseService, JourneyServiceType {
    let event = PublishSubject<JourneyEvent>()
    
    func fetchJornenys() -> Observable<BaseModel<FetchJourneysResponse>> {
        let target = JourneyAPI.fetchJourneys
        
        return APIService.request(target: target)
            .map(BaseModel<FetchJourneysResponse>.self)
            .asObservable()
    }
    
    func fetchJorney(journeyId: String) -> RxSwift.Observable<BaseModel<Journey>> {
        let target = JourneyAPI.fetchJourney(journeyId: journeyId)
        
        return APIService.request(target: target)
            .map(BaseModel<Journey>.self)
            .asObservable()
    }
    
    func fetchDefaultTags() -> Observable<BaseModel<FetchTagsResponse>> {
        let target = JourneyAPI.fetchDefaultTags
        
        return APIService.request(target: target)
            .map(BaseModel<FetchTagsResponse>.self)
            .asObservable()
    }
    
    func createJourney(request: CreateJourneyRequest) -> Observable<BaseModel<CreateJourneyResponse>> {
        let target = JourneyAPI.createJourney(request: request)
        
        return APIService.request(target: target)
            .map(BaseModel<CreateJourneyResponse>.self)
            .asObservable()
    }
    
    func editTags(journeyId: String, request: UpdateTagsRequest) -> Observable<EmptyModel> {
        let target = JourneyAPI.updateTags(journeyId: journeyId, request: request)
        
        return APIService.request(target: target)
            .map(EmptyModel.self)
            .asObservable()
    }
    
    func addJourneyUser(journeyId: String, request: CreateJourneyUserRequest) -> Observable<EmptyModel> {
        let target = JourneyAPI.createJourneyUser(journeyId: journeyId, request: request)
        
        return APIService.request(target: target)
            .map(EmptyModel.self)
            .asObservable()
    }
    
    func deleteJourneyUser(journeyId: String) -> RxSwift.Observable<EmptyModel> {
        let target = JourneyAPI.deleteJourneyUser(journeyId: journeyId)
        
        return APIService.request(target: target)
            .map(EmptyModel.self)
            .asObservable()
    }
    
    func addPikmiLike(journeyId: String, pikmiId: String) -> RxSwift.Observable<EmptyModel> {
        let target = JourneyAPI.createPikmiLike(journeyId: journeyId, pikmiId: pikmiId)
        
        return APIService.request(target: target)
            .map(EmptyModel.self)
            .asObservable()
    }
    
    func deletePikmiLike(journeyId: String, pikmiId: String) -> RxSwift.Observable<EmptyModel> {
        let target = JourneyAPI.deletePikmiLike(journeyId: journeyId, pikmiId: pikmiId)
        
        return APIService.request(target: target)
            .map(EmptyModel.self)
            .asObservable()
    }
}
