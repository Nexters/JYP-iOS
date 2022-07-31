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
        createPlannerButton.setTitle("플래너 생성", for: .normal)
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

        createPlannerButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
    }

    override func setupBind() {
        createPlannerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let createPlannerDateViewController = CreatePlannerDateViewController()

                self?.navigationController?.pushViewController(createPlannerDateViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
