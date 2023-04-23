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

    private let coverImage: UIImageView = .init()
    private let daysTag: UIButton = .init()
    private(set) var moreButton: UIButton = .init()
    private let titleLabel: UILabel = .init()
    private let startDateLabel: UILabel = .init()
    private let endDateLabel: UILabel = .init()
    private var memberStackView: JYPMemberStackView = .init()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        daysTag.snp.updateConstraints { make in
            make.height.equalTo(29)
        }

        titleLabel.snp.updateConstraints { make in
            make.top.equalTo(daysTag.snp.bottom).offset(16)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Setup

    override func setupProperty() {
        super.setupProperty()

        cornerRound(radius: 16)
        clipsToBounds = true

        daysTag.isEnabled = false
        daysTag.setTitle("D-20", for: .normal)
        daysTag.titleLabel?.font = JYPIOSFontFamily.Pretendard.bold.font(size: 14)
        daysTag.cornerRound(radius: 6)
        daysTag.backgroundColor = JYPIOSAsset.subBlack.color
        daysTag.setTitleColor(JYPIOSAsset.textWhite.color, for: .normal)

        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 22)

        startDateLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
        endDateLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        addSubviews([coverImage, daysTag, moreButton, titleLabel, startDateLabel, endDateLabel, memberStackView])
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

        startDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
        }

        endDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(startDateLabel.snp.trailing)
            make.centerY.equalTo(startDateLabel)
        }

        memberStackView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(20)
        }
    }

    func bind(reactor: JourneyCardCollectionViewCellReactor) {
        let journey = reactor.currentState.journey

        coverImage.image = journey.themePath.image
        backgroundColor = journey.themePath.cardColor
        if journey.themePath.isActiveShadow {
            setShadow(radius: 40, offset: .init(width: 4, height: 10), opacity: 0.06)
        } else {
            layer.shadowColor = nil
        }

        moreButton.setImage(
            JYPIOSAsset.iconMenu.image.withTintColor(journey.themePath.textColor, renderingMode: .alwaysOriginal),
            for: .normal
        )
        titleLabel.text = journey.name
        titleLabel.textColor = journey.themePath.textColor
        
        if Date(timeIntervalSince1970: journey.endDate) < Date() {
            startDateLabel.text = DateManager.doubleToDateString(format: "YY.MM.dd ", double: journey.startDate)
            endDateLabel.text = "- \(DateManager.doubleToDateString(format: "YY.MM.dd", double: reactor.currentState.journey.endDate))"
        } else {
            startDateLabel.text = DateManager.doubleToDateString(format: "M월 d일", double: journey.startDate)
            endDateLabel.text = "- \(DateManager.doubleToDateString(format: "M월 d일", double: reactor.currentState.journey.endDate))"
        }
        
        startDateLabel.textColor = journey.themePath.textColor
        endDateLabel.textColor = journey.themePath.textColor

        memberStackView.users = journey.users
        memberStackView.borderColor = journey.themePath.borderColor

        if let day = DateManager.calcDays(from: journey.startDate) {
            var daysText = "\(day)"
            if day == 0 {
                daysText = "-day"
            } else if day > 0 {
                daysText = "+\(day)"
            }
            daysTag.setTitle("D\(daysText)", for: .normal)
        }
    }

    func hideDaysTag() {
        daysTag.snp.updateConstraints { make in
            make.height.equalTo(0)
        }

        titleLabel.snp.updateConstraints { make in
            make.top.equalTo(daysTag.snp.bottom).offset(0)
        }
    }
}
