//
//  JYPNetworkError.swift
//  JYP-iOS
//
//  Created by inae Lee on 2023/01/24.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import Foundation

enum JYPNetworkError: Error {
    /// 잘못된 참여코드 - 40001
    case invalidCode(String)
    /// 입장 인원 초과 - 40002
    case exceededUser(String)
    /// 존재하지 않는 여행 (삭제, 여행 기간이 지남) - 40003
    case notExistJourney(String)
    /// 이미 참여 중인 여행 - 40005
    case alreadyJoinedJourney(String)
    /// 정의되지 않은 모든 에러 (Internal Server Error 포함)
    case serverError(String)
}
