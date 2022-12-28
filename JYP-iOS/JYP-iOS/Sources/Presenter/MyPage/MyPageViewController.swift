//
//  MyPageViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/20.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class MyPageViewController: NavigationBarViewController {
    // MARK: - UI Components

    let headerView: UIView = .init()
    let profileImageView: UIImageView = .init()
    let typeLabel: UILabel = .init()
    let nicknameLabel: UILabel = .init()

    let stackView: UIStackView = .init()

    let noticeButton: MyPageButton = .init(title: "공지사항")
    let versionButton: MyPageButton = .init(title: "버전 정보", info: "1.0")
    let logoutButton: MyPageButton = .init(title: "로그아웃")

    // MARK: - Initializer

    // MARK: - Setup Methods

    override func setupNavigationBar() {
        super.setupNavigationBar()

        setNavigationBarTitleText("마이페이지")
        setNavigationBarTitleTextColor(JYPIOSAsset.textB75.color)
        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.medium.font(size: 16))
        setNavigationBarBackgroundColor(JYPIOSAsset.backgroundWhite100.color)
        setNavigationBarBackButtonHidden(true)
    }

    override func setupProperty() {
        super.setupProperty()

        view.backgroundColor = JYPIOSAsset.backgroundWhite200.color

        headerView.backgroundColor = JYPIOSAsset.backgroundWhite100.color
        headerView.setContentHuggingPriority(.defaultHigh, for: .vertical)

        profileImageView.image = JYPIOSAsset.profile2.image

        typeLabel.text = "자유로운 탐험가"
        typeLabel.numberOfLines = 1
        typeLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 22)
        typeLabel.lineSpacing(lineHeight: 34.1)
        typeLabel.textAlignment = .center
        typeLabel.textColor = JYPIOSAsset.textB90.color

        nicknameLabel.text = "윤다다"
        nicknameLabel.numberOfLines = 1
        nicknameLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        nicknameLabel.lineSpacing(lineHeight: 24)
        nicknameLabel.textAlignment = .center
        nicknameLabel.textColor = JYPIOSAsset.textB80.color

        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 12.0
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        [noticeButton, versionButton, logoutButton].forEach { stackView.addArrangedSubview($0) }

        contentView.addSubviews([headerView, profileImageView, typeLabel, nicknameLabel, stackView])
    }

    override func setupLayout() {
        super.setupLayout()

        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(nicknameLabel.snp.bottom).offset(30).priority(.high)
        }

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.size.equalTo(88)
        }

        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }

        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }

    override func setupBind() {
        super.setupBind()

        noticeButton.rx.tap
            .subscribe(onNext: { [weak self] in
//                self?.navigationController?.pushViewController(TempViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
