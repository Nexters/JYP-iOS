//
//  MyPlannerViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/17.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import UIKit

class MyPlannerViewController: NavigationBarViewController {
    // MARK: - UI Components

    let headerView: UIView = .init()
    let titleLabel: UILabel = .init()

    let scheduledJourneyButton: JYPBottomBorderButton = .init(title: "준비된 여행")
    let pastJourneyButton: JYPBottomBorderButton = .init(title: "지난 여행기")

    // MARK: - Setup Methods

    override func setupNavigationBar() {
        super.setupNavigationBar()

        setNavigationBarTitleText("나의 여행")
        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.medium.font(size: 16))
        setNavigationBarBackgroundColor(JYPIOSAsset.backgroundWhite200.color)
        setNavigationBarBackButtonHidden(true)
    }

    override func setupProperty() {
        super.setupProperty()

        headerView.backgroundColor = JYPIOSAsset.backgroundWhite200.color

        titleLabel.text = "자유로운 탐험가,\n다정님의 시작된 여행"
        titleLabel.numberOfLines = 0
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 22)
        titleLabel.textColor = JYPIOSAsset.textB90.color
        
        scheduledJourneyButton.isSelected = true
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        contentView.addSubviews([headerView, titleLabel, scheduledJourneyButton, pastJourneyButton])
    }

    override func setupLayout() {
        super.setupLayout()

        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.bottom).offset(40)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.equalToSuperview().inset(24)
        }

        scheduledJourneyButton.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(24)
        }

        pastJourneyButton.snp.makeConstraints { make in
            make.centerY.equalTo(scheduledJourneyButton.snp.centerY)
            make.leading.equalTo(scheduledJourneyButton.snp.trailing).offset(28)
        }
    }
}
