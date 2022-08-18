//
//  JYPMemberStackView.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/18.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class JYPMemberStackView: UIStackView {
    static let MAX_MEMBER = 3

    // MARK: - Properties

    var profiles: [JYPProfileImageView] = [
        .init(frame: .zero),
        .init(frame: .zero),
        .init(frame: .zero),
        .init(frame: .zero),
        .init(frame: .zero)
    ]

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupProperty()
        setupLayout()
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addArrangedSubview(_ view: UIView) {
        super.addArrangedSubview(view)
        sendSubviewToBack(view)
    }

    func setupProperty() {
        spacing = -18.0
        axis = .horizontal
        distribution = .fillProportionally
    }

    func setupLayout() {
        // TODO: - User Model 정의 후 변경

        profiles
            .prefix(Self.MAX_MEMBER)
            .forEach {
                addArrangedSubview($0)
            }

        if profiles.count > Self.MAX_MEMBER {
            let overMember = JYPOverProfileView(count: profiles.count)

            addArrangedSubview(overMember)
        }
    }
}

// MARK: - JYPProfileImageView

class JYPProfileImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupProperty()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupProperty() {
        image = JYPIOSAsset.cardIllust4.image
        clipsToBounds = true

        cornerRound(radius: 12)
        makeBorder(color: JYPIOSAsset.tagBlue100.color, width: 2.18)
    }

    func setupLayout() {
        snp.makeConstraints { make in
            make.size.equalTo(44)
        }
    }
}

// MARK: - JYPOverProfileView

class JYPOverProfileView: UIView {
    let countLabel: UILabel = .init().then {
        $0.font = JYPIOSFontFamily.Pretendard.bold.font(size: 11)
        $0.textColor = JYPIOSAsset.textWhite.color
    }

    init(count: Int) {
        super.init(frame: .zero)

        setupProperty(count: count)
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupProperty(count: Int) {
        clipsToBounds = true

        countLabel.text = "+\(count - JYPMemberStackView.MAX_MEMBER)"
        backgroundColor = JYPIOSAsset.textB75.color
        cornerRound(radius: 12)
        makeBorder(color: .clear, width: 2.18)
    }

    func setupLayout() {
        addSubview(countLabel)

        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(9)
        }

        snp.makeConstraints { make in
            make.size.equalTo(44)
        }
    }
}
