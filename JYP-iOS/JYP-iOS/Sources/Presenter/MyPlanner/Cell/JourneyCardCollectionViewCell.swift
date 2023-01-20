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
    private let moreButton: UIButton = .init()
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
        reactor.state
            .map(\.journey.themePath.image)
            .bind(to: coverImage.rx.image)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.users)
            .bind(to: memberStackView.rx.profiles)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.themePath.isActiveShadow)
            .bind(to: rx.isActiveShadow)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.themePath.cardColor)
            .bind(to: rx.backgroundColor)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.themePath.borderColor)
            .bind(to: memberStackView.rx.borderColor)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.themePath.textColor)
            .bind(to: titleLabel.rx.textColor)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.themePath.textColor)
            .bind(to: startDateLabel.rx.textColor)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.themePath.textColor)
            .bind(to: endDateLabel.rx.textColor)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.themePath.textColor)
            .map { JYPIOSAsset.iconMenu.image.withTintColor($0, renderingMode: .alwaysOriginal) }
            .bind(to: moreButton.rx.image(for: .normal))
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.name)
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.startDate)
            .map { DateManager.doubleToDateString(format: "M월 d일", double: $0) }
            .bind(to: startDateLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.startDate)
            .compactMap { DateManager.calcDays(from: $0) }
            .map { day in
                var tag = String(day)

                if day == 0 {
                    tag = "-day"
                } else if day > 0 {
                     tag = "+\(day)"
                }
                return "D\(tag)"
            }
            .bind(to: daysTag.rx.title())
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.endDate)
            .map { "- \(DateManager.doubleToDateString(format: "M월 d일", double: $0))" }
            .bind(to: endDateLabel.rx.text)
            .disposed(by: disposeBag)
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

extension Reactive where Base: JourneyCardCollectionViewCell {
    var isActiveShadow: Binder<Bool> {
        Binder(base) { view, isActive in
            if isActive {
                view.setShadow(radius: 40, offset: .init(width: 4, height: 10), opacity: 0.06)
            } else {
                view.layer.shadowColor = nil
            }
        }
    }
}
