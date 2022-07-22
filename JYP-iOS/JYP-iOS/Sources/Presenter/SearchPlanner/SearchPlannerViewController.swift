//
//  SearchPlannerViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/17.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import UIKit

class SearchPlannerViewController: BaseViewController {
    let titleLabel = UILabel()
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.text = "플래너 탐색 뷰컨"
        titleLabel.textColor = .black
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubview(titleLabel)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    override func setupBind() {
        let target = SearchAPI.placeSearch(keyword: "아르떼 뮤지엄")

        APIService.request(target: target)
            .map(KakaoResponse.self)
            .subscribe { response in
                print(response)
            }
            .disposed(by: disposeBag)
    }
}
