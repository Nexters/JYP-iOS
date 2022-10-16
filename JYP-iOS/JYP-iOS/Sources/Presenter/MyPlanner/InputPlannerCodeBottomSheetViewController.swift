//
//  InputPlannerCodeBottomSheetViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/10/03.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

class InputPlannerCodeBottomSheetViewController: BottomSheetViewController, View {
    typealias Reactor = InputPlannerCodeBottomSheetReactor

    // MARK: - Properties

    private let containerView: UIView = .init()

    private let titleLabel: UILabel = .init()
    private let cancelButton: UIButton = .init()

    private let plannerCodeLabel: UILabel = .init()
    private let guideLabel: UILabel = .init()

    private let textField: JYPSearchTextField = .init(type: .tag)

    private let plannerJoinButton: JYPButton = .init(type: .plannerJoin)

    private let joinCodeButton: UIButton = .init()

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - Initializer

    init(reactor: Reactor) {
        super.init(mode: .drag)
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    override func setupProperty() {
        super.setupProperty()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(changedClipboardString),
            name: Notification.Name.changeClipboardString,
            object: nil
        )

        titleLabel.text = "플래너 입장하기"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 18)
        titleLabel.textColor = JYPIOSAsset.textB90.color
        titleLabel.lineSpacing(lineHeight: 27)

        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(JYPIOSAsset.textB40.color, for: .normal)

        plannerCodeLabel.text = "참여 코드"
        plannerCodeLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
        plannerCodeLabel.textColor = JYPIOSAsset.textB75.color

        guideLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        guideLabel.textColor = JYPIOSAsset.mainPink.color

        textField.textField.leftView = UIView()
        textField.setupToolBar()

        joinCodeButton.backgroundColor = JYPIOSAsset.tagWhiteBlue100.color
        joinCodeButton.setTitleColor(JYPIOSAsset.subBlue300.color, for: .normal)
        joinCodeButton.titleLabel?.lineBreakMode = .byTruncatingTail
        joinCodeButton.cornerRound(radius: 8)
        joinCodeButton.isHidden = true

        setJoinCodeButton(UIPasteboard.general.string)
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        containerView.addSubviews([
            titleLabel,
            cancelButton,
            plannerCodeLabel,
            guideLabel,
            textField,
            plannerJoinButton,
            joinCodeButton
        ])
        addContentView(view: containerView)
    }

    override func setupLayout() {
        super.setupLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        cancelButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.height.equalTo(titleLabel)
        }

        plannerCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(38)
            make.leading.equalTo(titleLabel.snp.leading)
        }

        guideLabel.snp.makeConstraints { make in
            make.centerY.equalTo(plannerCodeLabel.snp.centerY)
            make.trailing.equalTo(cancelButton.snp.trailing)
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(plannerCodeLabel.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(39)
        }

        joinCodeButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.width.equalTo(104)
        }

        plannerJoinButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(339).priority(.low)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(52)
        }
    }

    func bind(reactor: InputPlannerCodeBottomSheetReactor) {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)

        joinCodeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.textField.textField.text = self?.joinCodeButton.title(for: .normal)
            })
            .disposed(by: disposeBag)

        plannerJoinButton.rx.tap
            .map { Reactor.Action.didTapJoinCodeButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        textField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { .didChangedTextField($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isActivePlannerJoinButton)
            .bind(to: plannerJoinButton.rx.isEnabled)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isPushMyPlannerView)
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                let plannerReactor = PlannerReactor(
                    state: .init(pik:
                        Pik(
                            id: "",
                            name: "",
                            address: "",
                            category: .bank,
                            likeBy: nil,
                            longitude: 0.0,
                            latitude: 0.0,
                            link: ""
                        )
                    )
                )
                let plannerViewController = PlannerViewController(reactor: plannerReactor)

                guard let presentingViewContoller = self?.presentingViewController as? UINavigationController else { return }
                self?.dismiss(animated: true, completion: {
                    presentingViewContoller.pushViewController(
                        plannerViewController,
                        animated: true
                    )
                })
            })
            .disposed(by: disposeBag)
    }

    private
    func setJoinCodeButton(_ text: String?) {
        guard let clipboardString = text else { return }

        joinCodeButton.isHidden = false
        joinCodeButton.setTitle(clipboardString, for: .normal)
    }

    @objc
    func changedClipboardString(_ sender: Notification) {
        guard let clipboardString: String = sender.object as? String else { return }

        setJoinCodeButton(clipboardString)
    }
}
