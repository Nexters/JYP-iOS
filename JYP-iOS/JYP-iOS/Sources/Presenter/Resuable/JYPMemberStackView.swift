//
//  JYPMemberStackView.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/18.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxSwift
import UIKit

class JYPMemberStackView: UIStackView {
    static let MAX_MEMBER = 3

    // MARK: - Properties

    var users: [User] = [] {
        didSet {
            setupLayout()
        }
    }

    // MARK: - Initializer

    init() {
        super.init(frame: .zero)

        setupProperty()
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
        arrangedSubviews.forEach { $0.removeFromSuperview() }

        users
            .prefix(Self.MAX_MEMBER)
            .map { $0.profileImagePath }
            .forEach { url in
                let profile = JYPProfileImageView()
                profile.kf.setImage(with: URL(string: url))

                addArrangedSubview(profile)
            }

        if users.count > Self.MAX_MEMBER {
            let overMember = JYPOverProfileView(count: users.count)

            addArrangedSubview(overMember)
        }
    }
}

// MARK: - JYPProfileImageView

class JYPProfileImageView: UIImageView {
    init() {
        super.init(frame: .zero)

        setupProperty()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupProperty() {
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

extension Reactive where Base: JYPMemberStackView {
    var borderColor: Binder<UIColor> {
        Binder(base) { view, color in
            view.arrangedSubviews.forEach { $0.layer.borderColor = color.cgColor }
        }
    }
}
