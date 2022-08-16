//
//  EmptyJourneyCardCollectionViewCell.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/16.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

class EmptyJourneyCardCollectionViewCell: BaseCollectionViewCell, View {
    typealias Reactor = EmptyJourneyCardCollectionViewCellReactor

    // MARK: - UI Components

    let icon: UIImageView = .init().then {
        $0.image = JYPIOSAsset.plannerCardStart.image
    }

    let guideLabel: UILabel = .init().then {
        $0.text = "새로운 여행 이야기를\n만들어주세요!"
        $0.numberOfLines = 0
        $0.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        $0.textColor = JYPIOSAsset.textB80.color
        $0.textAlignment = .center
    }

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupProperty()
        setupLayout()
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
            make.top.leading.trailing.equalToSuperview().inset(72)
            make.size.equalTo(136)
        }

        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - Bind

    func bind(reactor _: Reactor) {}
}
