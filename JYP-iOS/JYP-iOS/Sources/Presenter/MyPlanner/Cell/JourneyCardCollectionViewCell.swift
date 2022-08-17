//
//  JourneyCardCollectionViewCell.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/16.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

class JourneyCardCollectionViewCell: BaseCollectionViewCell, View {
    typealias Reactor = JourneyCardCollectionViewCellReactor

    // MARK: - UI Components

    let coverImage: UIImageView = .init()
    let daysTag: UIButton = .init()
    let moreButton: UIButton = .init()
    let titleLabel: UILabel = .init()
    let daysLabel: UILabel = .init()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Setup

    override func setupProperty() {
        super.setupProperty()

        cornerRound(radius: 16)
        clipsToBounds = true
        coverImage.image = JYPIOSAsset.cardIllust2.image
        backgroundColor = .init(hex: 0x88C4FF)

        daysTag.isEnabled = false
        daysTag.setTitle("D-20", for: .normal)
        daysTag.titleLabel?.font = JYPIOSFontFamily.Pretendard.bold.font(size: 14)
        daysTag.cornerRound(radius: 6)
        daysTag.backgroundColor = JYPIOSAsset.subBlack.color
        daysTag.setTitleColor(JYPIOSAsset.textWhite.color, for: .normal)

        moreButton.setImage(JYPIOSAsset.iconMenu.image.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)

        titleLabel.text = "강릉 여행기"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 22)
        titleLabel.textColor = JYPIOSAsset.textWhite.color

        daysLabel.text = "7월 18일 - 7월 20일"
        daysLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
        daysLabel.textColor = JYPIOSAsset.textWhite.color
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        addSubviews([coverImage, daysTag, moreButton, titleLabel, daysLabel])
    }

    override func setupLayout() {
        super.setupLayout()

        coverImage.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }

        daysTag.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
            make.width.equalTo(52)
            make.height.equalTo(29)
        }

        moreButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(16)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(daysTag.snp.bottom).offset(16)
            make.leading.equalTo(daysTag.snp.leading)
        }

        daysLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
        }
    }

    func bind(reactor: JourneyCardCollectionViewCellReactor) {
        reactor.state
            .map(\.journey.name)
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
