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
    private let textField: JYPSearchTextField = .init(type: .planner)

    private let nextButton: JYPButton = .init(type: .next)

    // MARK: - Initializer

    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
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

        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 24)
        titleLabel.text = "여행기 제목은 무엇인가요?"
        titleLabel.textColor = JYPIOSAsset.textB90.color

        subTitleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        subTitleLabel.textColor = JYPIOSAsset.textB40.color
        let subTitle = "최대 10글자까지 입력할 수 있어요"
        let attributedString = NSMutableAttributedString(string: subTitle)
        attributedString.addAttribute(.foregroundColor, value: JYPIOSAsset.textB80.color, range: (subTitle as NSString).range(of: "최대 10글자"))
        subTitleLabel.attributedText = attributedString

        textField.textField.leftView = UIView()
        textField.setupToolBar()
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        contentView.addSubviews([titleLabel, subTitleLabel, textField, nextButton])
    }

    override func setupLayout() {
        super.setupLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(24)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(56)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(24)
            make.height.equalTo(40)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(52)
        }
    }

    // MARK: - Bind

    func bind(reactor: Reactor) {
        rx.viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.textField.textField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Objc Method

    @objc
    func didTapDoneButton(_ sender: UIBarButtonItem) {
        textField.resignFirstResponder()
    }
}
