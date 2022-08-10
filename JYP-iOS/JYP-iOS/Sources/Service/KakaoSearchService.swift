//
//  SearchService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/09.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxSwift

enum KakaoSearchEvent {
    case searchPlace(String, Int)
}

protocol KakaoSearchServiceType {
    var event: PublishSubject<KakaoSearchEvent> { get }
    
    func searchPlace(keyword: String, page: Int) -> Observable<KakaoSearchResponse>
}

class KakaoSearchService: BaseService, KakaoSearchServiceType {
    var event = PublishSubject<KakaoSearchEvent>()
    
    func searchPlace(keyword: String, page: Int) -> Observable<KakaoSearchResponse> {
        return Observable<KakaoSearchResponse>.create { emitter in
            let target = SearchAPI.placeSearch(keyword: keyword, page: page)
            
            APIService.request(target: target)
                .map(KakaoSearchResponse.self)
                .subscribe { response in
                    switch response {
                    case .success(let data):
                        emitter.onNext(data)
                    case .failure: break
                    }
                }
                .dispose()
            
            return Disposables.create()
        }
    }
}
