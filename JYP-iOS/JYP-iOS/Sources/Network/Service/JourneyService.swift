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
    case updatePikis(ids: [String])
    case createPikmiLike
    case deletePikmiLike

    /// local
    case changeJourneyData(_ journey: Journey)
    case didFinishCreatePlanner(_ id: String)
    case requestRefreshJourneys
}

protocol JourneyServiceType {
    var event: PublishSubject<JourneyEvent> { get }

    func fetchJornenys()
    func fetchJorney(id: String)
    func fetchDefaultTags() -> Observable<[Tag]>
    func fetchJourneyTags(journeyId: String, isIncludeDefaultTags: Bool) -> Observable<[Tag]>
    func createJourney(journey: Journey) -> Observable<String>
    func createPikmi(id: String, name: String, address: String, category: JYPCategoryType, longitude: Double, latitude: Double, link: String)
    func updatePikis(journeyId: String, request: UpdatePikisRequest)
    func editTags(journeyId: String, request: UpdateTagsRequest) -> Observable<EmptyModel>
    func joinPlanner(journeyId: String, request: CreateJourneyUserRequest) -> Observable<EmptyModel>
    func deleteJourneyUser(journeyId: String) -> Observable<EmptyModel>
    func createPikmiLike(journeyId: String, pikmiId: String)
    func deletePikmiLike(journeyId: String, pikmiId: String)

    /// local
    func changeJourneyData(_ journey: Journey?)
    func didFinishCreatePlanner(_ id: String)
    func requestRefreshJourneys()
}

final class JourneyService: BaseService, JourneyServiceType {
    let event = PublishSubject<JourneyEvent>()

    func changeJourneyData(_ journey: Journey?) {
        guard let journey else { return }
        event.onNext(.changeJourneyData(journey))
    }

    func didFinishCreatePlanner(_ id: String) {
        event.onNext(.didFinishCreatePlanner(id))
    }

    func requestRefreshJourneys() {
        event.onNext(.requestRefreshJourneys)
    }

    func fetchJornenys() {
        let target = JourneyAPI.fetchJourneys

        let request = APIService.request(target: target)
            .map(BaseModel<FetchJourneysResponse>.self)
            .compactMap(\.data)
            .map { $0.toDomain() }
            .asObservable()

        request.subscribe { [weak self] journeyList in
            self?.event.onNext(.fetchJourneyList(journeyList))
        }
        .disposed(by: disposeBag)
    }

    func fetchJorney(id: String) {
        let target = JourneyAPI.fetchJourney(journeyId: id)

        let request = APIService.request(target: target)
            .map(BaseModel<FetchJourneyDetailResponse>.self)
            .compactMap(\.data)
            .map { $0.toDomain() }
            .asObservable()

        request.bind { [weak self] journey in
            self?.event.onNext(.fetchJourney(journey))
        }
        .disposed(by: disposeBag)
    }

    func fetchJourneyTags(
        journeyId: String,
        isIncludeDefaultTags: Bool
    ) -> Observable<[Tag]> {
        let target = JourneyAPI.fetchJourneyTags(journeyId: journeyId, isIncludeDefault: isIncludeDefaultTags)

        return APIService.request(target: target)
            .map(BaseModel<FetchTagsResponse>.self)
            .compactMap(\.data)
            .map(\.tags)
            .asObservable()
    }

    func fetchDefaultTags() -> Observable<[Tag]> {
        let target = JourneyAPI.fetchDefaultTags

        return APIService.request(target: target)
            .map(BaseModel<FetchTagsResponse>.self)
            .compactMap(\.data)
            .map(\.tags)
            .asObservable()
    }

    func createJourney(journey: Journey) -> Observable<String> {
        let createJourneyRequest = CreateJourneyRequest(
            name: journey.name,
            startDate: journey.startDate,
            endDate: journey.endDate,
            themePath: journey.themePath.rawValue,
            tags: journey.tags
        )
        let target = JourneyAPI.createJourney(request: createJourneyRequest)

        return APIService.request(target: target)
            .map(BaseModel<CreateJourneyResponse>.self)
            .compactMap(\.data)
            .map(\.id)
            .asObservable()
    }

    func createPikmi(id: String, name: String, address: String, category: JYPCategoryType, longitude: Double, latitude: Double, link: String) {
        let target = JourneyAPI.createPikmi(journeyId: id, request: .init(name: name, address: address, category: category.rawValue, longitude: longitude, latitude: latitude, link: link))

        let request = APIService.request(target: target)
            .map(BaseModel<CreatePikmiResponse>.self)
            .compactMap(\.data)
            .map(\.id)
            .asObservable()

        request.bind { [weak self] id in
            self?.event.onNext(.createPikmi(id: id))
        }
        .disposed(by: disposeBag)
    }

    func updatePikis(journeyId: String, request: UpdatePikisRequest) {
        let target = JourneyAPI.updatePikis(journeyId: journeyId, request: request)

        let request = APIService.request(target: target)
            .map(BaseModel<UpdatePikisResponse>.self)
            .compactMap(\.data)
            .map(\.ids)
            .asObservable()

        request.bind { [weak self] ids in
            self?.event.onNext(.updatePikis(ids: ids))
        }
        .disposed(by: disposeBag)
    }

    func editTags(journeyId: String, request: UpdateTagsRequest) -> Observable<EmptyModel> {
        let target = JourneyAPI.updateTags(journeyId: journeyId, request: request)

        return APIService.request(target: target)
            .map(EmptyModel.self)
            .asObservable()
    }

    func joinPlanner(journeyId: String, request: CreateJourneyUserRequest) -> Observable<EmptyModel> {
        let target = JourneyAPI.joinPlanner(
            journeyId: journeyId,
            request: request
        )

        return APIService.request(target: target)
            .map(EmptyModel.self)
            .flatMap { model in
                .create { observer in
                    switch model.code {
                    case "20000": observer(.success(model))
                    case "40001": observer(.failure(JYPNetworkError.invalidCode(model.message)))
                    case "40002": observer(.failure(JYPNetworkError.exceededUser(model.message)))
                    case "40003": observer(.failure(JYPNetworkError.notExistJourney(model.message)))
                    case "40005": observer(.failure(JYPNetworkError.alreadyJoinedJourney(model.message)))
                    default:
                        observer(.failure(JYPNetworkError.serverError(model.message)))
                    }

                    return Disposables.create()
                }
            }
            .asObservable()
    }

    func deleteJourneyUser(journeyId: String) -> RxSwift.Observable<EmptyModel> {
        let target = JourneyAPI.deleteJourneyUser(journeyId: journeyId)

        return APIService.request(target: target)
            .map(EmptyModel.self)
            .asObservable()
    }

    func createPikmiLike(journeyId: String, pikmiId: String) {
        let target = JourneyAPI.createPikmiLike(journeyId: journeyId, pikmiId: pikmiId)
        
        let request = APIService.request(target: target)
            .map(EmptyModel.self)
            .asObservable()
        
        request
            .filter({ $0.code == "20000" })
            .bind { [weak self] _ in
                self?.event.onNext(.createPikmiLike)
            }
            .disposed(by: disposeBag)
    }

    func deletePikmiLike(journeyId: String, pikmiId: String) {
        let target = JourneyAPI.deletePikmiLike(journeyId: journeyId, pikmiId: pikmiId)

        let request = APIService.request(target: target)
            .map(EmptyModel.self)
            .asObservable()
        
        request
            .filter({ $0.code == "20000" })
            .bind { [weak self] _ in
                self?.event.onNext(.deletePikmiLike)
            }
            .disposed(by: disposeBag)
    }
}
