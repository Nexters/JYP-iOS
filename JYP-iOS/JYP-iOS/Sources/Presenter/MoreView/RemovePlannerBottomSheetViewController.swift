//
//  RemovePlannerBottomSheetViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2023/01/29.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

final class RemovePlannerBottomSheetViewController: BottomSheetViewController, View {
    typealias Reactor = RemovePlannerBottomSheetReactor

    private let containerView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 20)
        label.textColor = JYPIOSAsset.textB80.color
        return label
    }()

    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = JYPIOSFontFamily.Pretendard.regular.font(size: 16)
        label.textColor = JYPIOSAsset.textB75.color
        label.text = "나간 플래너는 다시 확인할 수 없어요"
        return label
    }()

    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 12
        view.distribution = .fillEqually
        [noButton, yesButton].forEach { view.addArrangedSubview($0) }
        return view
    }()

    private let noButton: JYPButton = {
        let button = JYPButton(type: .no)
        button.isEnabled = true
        return button
    }()

    private let yesButton = JYPButton(type: .good)

    init(reactor: Reactor) {
        super.init(mode: .drag)
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        containerView.addSubviews([titleLabel, subTitleLabel, buttonStackView])
        addContentView(view: containerView)
    }

    override func setupLayout() {
        super.setupLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        buttonStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(subTitleLabel.snp.bottom).offset(67)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
            make.bottom.equalToSuperview()
        }
    }

    func bind(reactor: RemovePlannerBottomSheetReactor) {
        reactor.state
            .map(\.journey.name)
            .map { "\($0)에서 \n정말 나가시나요?" }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .filter(\.dismiss)
            .subscribe { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        noButton.rx.tap
            .map { Reactor.Action.didTapNoButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        yesButton.rx.tap
            .map { Reactor.Action.didTapYesButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
