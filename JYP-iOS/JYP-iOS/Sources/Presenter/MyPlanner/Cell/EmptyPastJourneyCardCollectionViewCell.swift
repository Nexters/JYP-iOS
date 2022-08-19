//
//  EmptyPastJourneyCardCollectionViewCell.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/20.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class EmptyPastJourneyCardCollectionViewCell: BaseCollectionViewCell {
    // MARK: - UI Components

    let icon: UIImageView = .init().then {
        $0.image = JYPIOSAsset.pastPlannerNo.image
    }

    let guideLabel: UILabel = .init().then {
        $0.text = "아직 여행을\n하지 않았어요!"
        $0.numberOfLines = 0
        $0.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        $0.textColor = JYPIOSAsset.textB75.color
        $0.textAlignment = .center
        $0.lineSpacing(lineHeight: 23.2)
    }

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

        setShadow(radius: 40.0, offset: .init(width: 4, height: 10), opacity: 0.06)
    }

    // MARK: - Setup

    override func setupProperty() {
        super.setupProperty()

        backgroundColor = JYPIOSAsset.backgroundWhite100.color
        cornerRound(radius: 16)
    }

    override func setupLayout() {
        super.setupLayout()

        addSubviews([icon, guideLabel])

        icon.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(104)
            make.centerX.equalToSuperview()
            make.size.equalTo(bounds.width * (136.0 / 280.0))
        }

        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
}
