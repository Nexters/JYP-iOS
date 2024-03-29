//
//  SelectionPlannerJoinBottomViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/09/24.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class SelectionPlannerJoinBottomViewController: BottomSheetViewController {
    private let pushInputPlannerCodeBottomSheetScreen: () -> InputPlannerCodeBottomSheetViewController

    // MARK: - UI Components

    private let containerView: UIView = .init()

    private let titleLabel: UILabel = .init()

    private let createPlannerView: UIView = .init()
    private let createPlannerIcon: UIImageView = .init()
    private let createPlannerLabel: UILabel = .init()

    private let joinPlannerView: UIView = .init()
    private let joinPlannerIcon: UIImageView = .init()
    private let joinPlannerLabel: UILabel = .init()

    init(
        mode: BottomSheetViewController.Mode,
        pushInputPlannerCodeBottomSheetScreen: @escaping () -> InputPlannerCodeBottomSheetViewController
    ) {
        self.pushInputPlannerCodeBottomSheetScreen = pushInputPlannerCodeBottomSheetScreen
        super.init(mode: mode)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupProperty() {
        super.setupProperty()

        titleLabel.text = "여행 시작하기"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 20)
        titleLabel.textColor = JYPIOSAsset.textB90.color

        createPlannerIcon.image = JYPIOSAsset.iconAdd.image
        createPlannerLabel.text = "플래너 생성하기"
        createPlannerLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        createPlannerLabel.textColor = JYPIOSAsset.textB75.color

        joinPlannerIcon.image = JYPIOSAsset.iconKey.image
        joinPlannerLabel.text = "참여 코드로 플래너 입장하기"
        joinPlannerLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        joinPlannerLabel.textColor = JYPIOSAsset.textB75.color
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        containerView.addSubviews([titleLabel, createPlannerView, joinPlannerView])
        createPlannerView.addSubviews([createPlannerIcon, createPlannerLabel])
        joinPlannerView.addSubviews([joinPlannerIcon, joinPlannerLabel])
        addContentView(view: containerView)
    }

    override func setupLayout() {
        super.setupLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        createPlannerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }

        createPlannerIcon.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(24)
        }

        createPlannerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(createPlannerIcon)
            make.leading.equalTo(createPlannerIcon.snp.trailing).offset(16)
        }

        joinPlannerView.snp.makeConstraints { make in
            make.top.equalTo(createPlannerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(containerView.snp.bottom).offset(-24)
            make.height.equalTo(30)
        }

        joinPlannerIcon.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.size.equalTo(24)
        }

        joinPlannerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(joinPlannerIcon)
            make.leading.equalTo(joinPlannerIcon.snp.trailing).offset(16)
        }
    }

    override func setupBind() {
        super.setupBind()

        createPlannerView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self,
                      let tabBarController = self.presentingViewController as? UITabBarController,
                      let firstViewController = tabBarController.children.first as? UINavigationController
                else { return }

                self.dismiss(animated: true, completion: {
                    let createPlannerViewController = CreatePlannerNameViewController(reactor: .init())
                    createPlannerViewController.hidesBottomBarWhenPushed = true

                    firstViewController.pushViewController(createPlannerViewController, animated: true)
                })
            })
            .disposed(by: disposeBag)

        joinPlannerView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self,
                      let tabBarController = self.presentingViewController as? UITabBarController
                else { return }

                self.dismiss(animated: true, completion: {
                    let viewController = self.pushInputPlannerCodeBottomSheetScreen()
                    tabBarController.present(viewController, animated: true)
                })
            })
            .disposed(by: disposeBag)
    }
}
