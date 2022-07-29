//
//  MyPlannerViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/17.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import UIKit

class MyPlannerViewController: BaseViewController {
    // MARK: - UI Components

    let titleLabel = UILabel()
    let createPlannerButton = UIButton(type: .system)

    // MARK: - Setup Methods

    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.text = "마이 플래너 뷰컨"
        titleLabel.textColor = .black

        createPlannerButton.setTitle("생성하기", for: .normal)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()

        view.addSubviews([titleLabel, createPlannerButton])
    }
    
    override func setupLayout() {
        super.setupLayout()

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        createPlannerButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }

    override func setupBind() {
        super.setupBind()

        createPlannerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let calendarBottomSheet = CalendarViewController()
                calendarBottomSheet.modalPresentationStyle = .overCurrentContext

                self?.tabBarController?.present(calendarBottomSheet, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
