//
//  PlannerTagCollectionReusableView.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/09.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class PlannerTagCollectionReusableView: BaseCollectionReusableView {
    // MARK: - UI Components

    let titleLabel = UILabel()
    let addButton = UIButton()

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func setupProperty() {
        super.setupProperty()

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
            $0.leading.equalToSuperview()
        }

        addButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
}

extension Reactive where Base: PlannerTagCollectionReusableView {
    var didTapAddButton: ControlEvent<Void> {
        base.addButton.rx.tap
    }
}
