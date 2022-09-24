//
//  SelectPlannerCoverCollectionViewCell.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/09/04.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

class SelectPlannerCoverCollectionViewCell: BaseCollectionViewCell, View {
    typealias Reactor = SelectPlannerCoverCellReactor

    // MARK: - UI Components

    let coverImage: UIImageView = .init()
    let checkButton: UIButton = .init()
    let themeLabel: UILabel = .init()
    
    override var isSelected: Bool {
        didSet {
            checkButton.isSelected = isSelected
        }
    }

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

        coverImage.image = nil
        checkButton.isSelected = false
        themeLabel.text = nil

        layer.borderWidth = 0.0
    }

    // MARK: - Setup Methods

    override func setupProperty() {
        super.setupProperty()

        cornerRound(radius: 8)
        clipsToBounds = true

        themeLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)

        checkButton.setImage(JYPIOSAsset.iconCheck.image, for: .selected)
        checkButton.imageView?.contentMode = .scaleAspectFill
        checkButton.imageView?.clipsToBounds = false
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        addSubviews([coverImage, themeLabel, checkButton])
    }

    override func setupLayout() {
        super.setupLayout()

        coverImage.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(140)
        }

        themeLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(10)
        }

        checkButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(4)
            make.size.equalTo(40)
        }
    }

    func bind(reactor: Reactor) {
        reactor.state
            .map(\.theme.cardColor)
            .bind(to: rx.backgroundColor)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.theme.image)
            .bind(to: coverImage.rx.image)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.theme.textColor)
            .bind(to: themeLabel.rx.textColor)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.theme.themeName)
            .bind(to: themeLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.theme.isActiveShadow)
            .bind(to: rx.isActiveShadow)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: SelectPlannerCoverCollectionViewCell {
    var isActiveShadow: Binder<Bool> {
        Binder(base) { view, isActive in
            if isActive {
                view.makeBorder(color: JYPIOSAsset.tagWhiteGrey100.color, width: 1.0)
            } else {
                view.layer.borderColor = nil
            }
        }
    }
}
