//
//  AnotherJourneyViewController.swift
//  JYP-iOSTests
//
//  Created by inae Lee on 2022/08/20.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class AnotherJourneyViewController: NavigationBarViewController {
    // MARK: - UI Components

    let icon: UIImageView = .init()
    let guideLabel: UILabel = .init()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Setup Methods

    override func setupNavigationBar() {
        super.setupNavigationBar()

        setNavigationBarTitleText("다른 여행기")
        setNavigationBarTitleTextColor(JYPIOSAsset.textB75.color)
        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.medium.font(size: 16))
        setNavigationBarBackgroundColor(JYPIOSAsset.backgroundWhite100.color)
        setNavigationBarBackButtonHidden(true)
    }

    override func setupProperty() {
        super.setupProperty()

        icon.image = JYPIOSAsset.anotherJourney.image

        guideLabel.numberOfLines = 0
        guideLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 16)
        guideLabel.textColor = JYPIOSAsset.textB75.color
        guideLabel.text = "다른 사람의 플래너 탐색 기능은\n업데이트 예정이에요!"
        guideLabel.lineSpacing(lineHeight: 24)
        guideLabel.textAlignment = .center
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        contentView.addSubviews([icon, guideLabel])
    }

    override func setupLayout() {
        super.setupLayout()

        icon.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(182)
            make.centerX.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(133)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
}
