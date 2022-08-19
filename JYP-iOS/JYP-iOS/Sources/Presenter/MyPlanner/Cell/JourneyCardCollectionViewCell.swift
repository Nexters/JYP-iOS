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
    let memberStackView: JYPMemberStackView = .init(frame: .zero)

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

        daysTag.isEnabled = false
        daysTag.setTitle("D-20", for: .normal)
        daysTag.titleLabel?.font = JYPIOSFontFamily.Pretendard.bold.font(size: 14)
        daysTag.cornerRound(radius: 6)
        daysTag.backgroundColor = JYPIOSAsset.subBlack.color
        daysTag.setTitleColor(JYPIOSAsset.textWhite.color, for: .normal)

        titleLabel.text = "강릉 여행기"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 22)

        daysLabel.text = "7월 18일 - 7월 20일"
        daysLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        addSubviews([coverImage, daysTag, moreButton, titleLabel, daysLabel, memberStackView])
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

        memberStackView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(20)
        }
    }

    func bind(reactor: JourneyCardCollectionViewCellReactor) {
        reactor.state
            .map(\.journey.themeUrl.image)
            .bind(to: coverImage.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.journey.themeUrl.isActiveShadow)
            .bind(to: rx.isActiveShadow)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.themeUrl.cardColor)
            .bind(to: rx.backgroundColor)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.themeUrl.borderColor)
            .bind(to: memberStackView.rx.borderColor)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.themeUrl.textColor)
            .bind(to: titleLabel.rx.textColor)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.themeUrl.textColor)
            .bind(to: daysLabel.rx.textColor)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.themeUrl.textColor)
            .map { JYPIOSAsset.iconMenu.image.withTintColor($0, renderingMode: .alwaysOriginal) }
            .bind(to: moreButton.rx.image(for: .normal))
            .disposed(by: disposeBag)

        reactor.state
            .map(\.journey.name)
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
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
