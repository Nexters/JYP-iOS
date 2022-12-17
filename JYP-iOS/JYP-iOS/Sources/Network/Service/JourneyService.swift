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
    case create(Journey)

    case changeJourneyData(_ journey: Journey)
}

protocol JourneyServiceType {
    var event: PublishSubject<JourneyEvent> { get }

    func fetchJornenys()
    func fetchJorney(journeyId: String) -> Observable<BaseModel<Journey>>
    func fetchDefaultTags() -> Observable<[Tag]>
    func fetchJourneyTags(journeyId: String, isIncludeDefaultTags: Bool) -> Observable<[Tag]>
    func createJourney(request: CreateJourneyRequest) -> Observable<BaseModel<CreateJourneyResponse>>
    func editTags(journeyId: String, request: UpdateTagsRequest) -> Observable<EmptyModel>
    func addJourneyUser(journeyId: String, request: CreateJourneyUserRequest) -> Observable<EmptyModel>
    func deleteJourneyUser(journeyId: String) -> Observable<EmptyModel>
    func addPikmiLike(journeyId: String, pikmiId: String) -> Observable<EmptyModel>
    func deletePikmiLike(journeyId: String, pikmiId: String) -> Observable<EmptyModel>

    /// local
    func changeJourneyData(_ journey: Journey?)
}

final class JourneyService: BaseService, JourneyServiceType {
    let event = PublishSubject<JourneyEvent>()

    func changeJourneyData(_ journey: Journey?) {
        guard let journey else { return }
        event.onNext(.changeJourneyData(journey))
    }

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

    func fetchJorney(journeyId: String) -> RxSwift.Observable<BaseModel<Journey>> {
        let target = JourneyAPI.fetchJourney(journeyId: journeyId)

        return APIService.request(target: target)
            .map(BaseModel<Journey>.self)
            .asObservable()
    }

    func fetchJourneyTags(
        journeyId: String,
        isIncludeDefaultTags: Bool
    ) -> Observable<[Tag]> {
        let target = JourneyAPI.fetchJourneyTags(journeyId: journeyId, isIncludeDefault: isIncludeDefaultTags)

        return APIService.request(target: target)
            .map(BaseModel<FetchTagsResponse>.self)
            .map(\.data.tags)
            .asObservable()
    }

    func fetchDefaultTags() -> Observable<[Tag]> {
        let target = JourneyAPI.fetchDefaultTags

        return APIService.request(target: target)
            .map(BaseModel<FetchTagsResponse>.self)
            .debug()
            .map(\.data.tags)
            .debug()
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
