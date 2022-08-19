//
//  MyPageViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/20.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class MyPageViewController: NavigationBarViewController {
    // MARK: - UI Components

    let headerView: UIView = .init()
    let profileImageView: UIImageView = .init()
    let typeLabel: UILabel = .init()
    let nicknameLabel: UILabel = .init()

    // MARK: - Initializer

    // MARK: - Setup Methods

    override func setupNavigationBar() {
        super.setupNavigationBar()

        setNavigationBarTitleText("마이페이지")
        setNavigationBarTitleTextColor(JYPIOSAsset.textB75.color)
        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.medium.font(size: 16))
        setNavigationBarBackgroundColor(JYPIOSAsset.backgroundWhite100.color)
        setNavigationBarBackButtonHidden(true)
    }

    override func setupProperty() {
        super.setupProperty()

        view.backgroundColor = JYPIOSAsset.backgroundWhite200.color

        headerView.backgroundColor = JYPIOSAsset.backgroundWhite100.color

        profileImageView.image = JYPIOSAsset.profile2.image

        typeLabel.text = "자유로운 탐험가"
        typeLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 22)
        typeLabel.lineSpacing(lineHeight: 34.1)
        typeLabel.textColor = JYPIOSAsset.textB90.color

        nicknameLabel.text = "윤다다"
        nicknameLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        nicknameLabel.lineSpacing(lineHeight: 24)
        nicknameLabel.textColor = JYPIOSAsset.textB80.color
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        contentView.addSubviews([headerView, profileImageView, typeLabel, nicknameLabel])
    }

    override func setupLayout() {
        super.setupLayout()

        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(nicknameLabel.snp.bottom).offset(30)
        }

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.size.equalTo(88)
        }

        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
    }
}
