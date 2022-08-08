//
//  CreatePlannerTagViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/07.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class CreatePlannerTagViewController: NavigationBarViewController {
    // MARK: - UI Components

    let titleLabel: UILabel = .init()
    let subTitleLabel: UILabel = .init()

    let layout: UICollectionViewFlowLayout = .init()
    lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)

    // MARK: - Setup Methods

    override func setupNavigationBar() {
        super.setupNavigationBar()

        setNavigationBarBackgroundColor(JYPIOSAsset.backgroundWhite100.color)
        setNavigationBarTitleText("여행 취향 태그")
        setNavigationBarTitleTextColor(JYPIOSAsset.textB80.color)
        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.medium.font(size: 16))
    }

    override func setupProperty() {
        super.setupProperty()

        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 24)
        titleLabel.text = "어떤 여행을 하고 싶으신가요?"
        titleLabel.textColor = JYPIOSAsset.textB90.color

        subTitleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        subTitleLabel.text = "일행과 공유할 태그를 최대 3개 선택해 주세요"
        titleLabel.textColor = JYPIOSAsset.textB40.color
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        contentView.addSubviews([titleLabel, subTitleLabel, collectionView])
    }

    override func setupLayout() {
        super.setupLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).inset(4)
            make.leading.equalToSuperview().inset(24)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(53)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
