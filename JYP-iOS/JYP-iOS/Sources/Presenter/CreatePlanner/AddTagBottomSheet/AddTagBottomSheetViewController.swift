//
//  AddTagBottomSheetViewController.swift
//  JYP-iOSTests
//
//  Created by inae Lee on 2022/08/13.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import UIKit

class AddTagBottomSheetViewController: BottomSheetViewController, View {
    typealias Reactor = AddTagBottomSheetReactor

    // MARK: - Properties

    private let containerView: UIView = .init()

    private let titleLabel: UILabel = .init()
    private let cancelButton: UIButton = .init()

    private let tagNameLabel: UILabel = .init()
    private let guideLabel: UILabel = .init()

    private let textField: JYPSearchTextField = .init(type: .tag)

    private let addButton: JYPButton = .init(type: .add)

    private let section: TagSection

    // MARK: - Initializer

    init(reactor: Reactor, section: TagSection) {
        self.section = section
        super.init(mode: .drag)
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle Method

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        guard reactor?.currentState.valid == .valid else { return }

        view.endEditing(true)
    }

    // MARK: - Setup Methods

    override func setupProperty() {
        super.setupProperty()

        titleLabel.text = "\(section.title) 생성"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 18)
        titleLabel.textColor = JYPIOSAsset.textB90.color

        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(JYPIOSAsset.textB40.color, for: .normal)

        tagNameLabel.text = "태그 이름"
        tagNameLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
        tagNameLabel.textColor = JYPIOSAsset.textB75.color

        guideLabel.text = "6글자 이하 가능"
        guideLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        guideLabel.textColor = JYPIOSAsset.subBlack.color

        textField.textField.leftView = UIView()

        addButton.isEnabled = false
        addButton.isHidden = true
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        containerView.addSubviews([titleLabel, cancelButton, tagNameLabel, guideLabel, textField, addButton])
        addContentView(view: containerView)
    }

    override func setupLayout() {
        super.setupLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }

        cancelButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
        }

        tagNameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(38)
            make.leading.equalTo(titleLabel.snp.leading)
        }

        guideLabel.snp.makeConstraints { make in
            make.centerY.equalTo(tagNameLabel.snp.centerY)
            make.trailing.equalTo(cancelButton.snp.trailing)
        }

        textField.snp.makeConstraints { make in
            make.top.equalTo(tagNameLabel.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(39)
        }

        addButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(339).priority(.low)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(52)
        }
    }

    // MARK: - Bind

    func bind(reactor: AddTagBottomSheetReactor) {
        rx.viewDidLoad
            .subscribe(onNext: { [weak self] in
                self?.textField.textField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)

        textField.textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.inputTextField($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.guideText)
            .bind(to: guideLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map(\.guideTextColor)
            .bind(to: guideLabel.rx.textColor)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.valid == .invalid }
            .bind(to: addButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
