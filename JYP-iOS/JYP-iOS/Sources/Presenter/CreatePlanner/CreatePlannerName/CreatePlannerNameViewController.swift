//
//  CreatePlannerNameViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/09/03.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

class CreatePlannerNameViewController: NavigationBarViewController, View {
    typealias Reactor = CreatePlannerNameReactor

    // MARK: - UI Components

    private let titleLabel: UILabel = .init()
    private let subTitleLabel: UILabel = .init()
    private let nextButton: JYPButton = .init(type: .next)

    // MARK: - Initializer

    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Setup Methods

    override func setupNavigationBar() {
        super.setupNavigationBar()

        setNavigationBarBackgroundColor(JYPIOSAsset.backgroundWhite100.color)
        setNavigationBarTitleText("여행 제목")
        setNavigationBarTitleTextColor(JYPIOSAsset.textB75.color)
        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.medium.font(size: 16))
    }

    override func setupProperty() {
        super.setupProperty()
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        contentView.addSubviews([titleLabel, subTitleLabel, nextButton])
    }

    override func setupLayout() {
        super.setupLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).inset(4)
            make.leading.equalToSuperview().inset(24)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(52)
        }
    }
    
    // MARK: - Bind
    
    func bind(reactor: CreatePlannerNameReactor) {
    }
}
