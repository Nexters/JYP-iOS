//
//  PlannerTagCollectionReusableView.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/09.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class PlannerTagCollectionReusableView: BaseCollectionReusableView {
    // MARK: - UI Components

    let titleLabel = UILabel()
    let addButton = UIButton()

    // MARK: - Properties

    var title: String

    // MARK: - Initializer

    init(title: String, isHiddenButton: Bool) {
        self.title = title
        addButton.isHidden = isHiddenButton
        
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupProperty() {
        super.setupProperty()

        titleLabel.text = "title"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        titleLabel.textColor = JYPIOSAsset.textB80.color

        addButton.setImage(JYPIOSAsset.iconAdd.image, for: .normal)
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        addSubviews([titleLabel, addButton])
    }

    override func setupLayout() {
        super.setupLayout()

        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(addButton.snp.centerY)
            $0.leading.equalToSuperview().inset(24)
        }

        addButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
            $0.size.equalTo(24)
        }
    }
}
