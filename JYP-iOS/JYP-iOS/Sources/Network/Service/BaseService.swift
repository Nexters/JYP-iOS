//
//  BaseService.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/09.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxSwift

class BaseService {
    var disposeBag = DisposeBag()
    unowned let provider: ServiceProviderType

    init(provider: ServiceProviderType) {
        self.provider = provider
    }
}
