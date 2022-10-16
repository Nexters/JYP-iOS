//
//  InputPlannerCodeBottomSheetViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/10/03.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import RxSwift

class InputPlannerCodeBottomSheetViewController: BottomSheetViewController {
    // MARK: - Properties

    private let containerView: UIView = .init()

    private let titleLabel: UILabel = .init()
    private let cancelButton: UIButton = .init()

    private let plannerCodeLabel: UILabel = .init()
    private let guideLabel: UILabel = .init()

    private let textField: JYPSearchTextField = .init(type: .tag)

    private let addButton: JYPButton = .init(type: .join)
    
    private let joinCodeButton: PlannerNameTagButton = .init(name: .yeosu)
    
    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Setup Methods

    override func setupProperty() {
        super.setupProperty()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(clipboardChanged),
            name: UIPasteboard.changedNotification,
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

        guideLabel.text = "잘못된 참여 코드에요"
        guideLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 12)
        guideLabel.textColor = JYPIOSAsset.mainPink.color

        textField.textField.leftView = UIView()
        textField.setupToolBar()
        
        joinCodeButton.isHidden = true
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        containerView.addSubviews([titleLabel, cancelButton, plannerCodeLabel, guideLabel, textField, addButton])
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

        addButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(339).priority(.low)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(52)
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func clipboardChanged() {
        guard let clipboardString: String = UIPasteboard.general.string else { return }

        print(clipboardString)
    }
}
