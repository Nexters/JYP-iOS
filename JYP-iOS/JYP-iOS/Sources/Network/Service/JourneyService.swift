//
//  JourneyService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/13.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxSwift

enum JourneyEvent {
    case fetchJourneyList([Journey])
    case fetchJourney(Journey)
    case create(Journey)
    case createPikmi(id: String)
}

protocol JourneyServiceType {
    var event: PublishSubject<JourneyEvent> { get }
    
    func fetchJornenys()
    func fetchJorney(id: String)
    func fetchDefaultTags() -> Observable<BaseModel<FetchTagsResponse>>
    func createJourney(request: CreateJourneyRequest) -> Observable<BaseModel<CreateJourneyResponse>>
    func createPikmi(id: String, name: String, address: String, category: JYPCategoryType, longitude: Double, latitude: Double, link: String)
    func editTags(journeyId: String, request: UpdateTagsRequest) -> Observable<EmptyModel>
    func addJourneyUser(journeyId: String, request: CreateJourneyUserRequest) -> Observable<EmptyModel>
    func deleteJourneyUser(journeyId: String) -> Observable<EmptyModel>
    func addPikmiLike(journeyId: String, pikmiId: String) -> Observable<EmptyModel>
    func deletePikmiLike(journeyId: String, pikmiId: String) -> Observable<EmptyModel>
}

final class JourneyService: BaseService, JourneyServiceType {
    let event = PublishSubject<JourneyEvent>()
    
    func fetchJornenys() {
        let target = JourneyAPI.fetchJourneys

        let request = APIService.request(target: target)
            .map(BaseModel<FetchJourneysResponse>.self)
            .map { $0.data.toDomain() }
            .asObservable()
        
        request.subscribe { [weak self] journeyList in
            self?.event.onNext(.fetchJourneyList(journeyList))
        }
        .disposed(by: disposeBag)
    }
    
    func fetchJorney(id: String) {
        let target = JourneyAPI.fetchJourney(journeyId: id)
        
        let request = APIService.request(target: target)
            .map(BaseModel<Journey>.self)
            .map { $0.data }
            .asObservable()
        
        request.bind { [weak self] journey in
            self?.event.onNext(.fetchJourney(journey))
        }
        .disposed(by: disposeBag)
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
    
    func createPikmi(id: String, name: String, address: String, category: JYPCategoryType, longitude: Double, latitude: Double, link: String) {
        let target = JourneyAPI.createPikmi(journeyId: id, request: .init(name: name, address: address, category: category.rawValue, longitude: longitude, latitude: latitude, link: link))
        
        let request = APIService.request(target: target)
            .map(BaseModel<CreatePikmiResponse>.self)
            .map { $0.data.id }
            .asObservable()
        
        request.bind { [weak self] id in
            self?.event.onNext(.createPikmi(id: id))
        }
        .disposed(by: disposeBag)
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
