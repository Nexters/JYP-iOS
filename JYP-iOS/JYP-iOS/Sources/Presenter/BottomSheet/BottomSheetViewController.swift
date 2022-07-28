//
//  BottomSheetViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/28.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import SnapKit
import UIKit

class BottomSheetViewController: BaseViewController {
    // MARK: - UI Components

    var sheetView: UIView!
    var dimmedView: UIView!

    // MARK: - Setup Methods

    override func setupProperty() {
        view.backgroundColor = .clear

        sheetView = .init().then {
            $0.backgroundColor = .white
        }
        
        dimmedView = .init().then {
            $0.backgroundColor = JYPIOSAsset.backgroundDim70.color
        }
    }

    override func setupHierarchy() {
        view.addSubviews([dimmedView, sheetView])
    }
    
    override func setupLayout() {
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    final func addContentView(view: UIView) {
        sheetView.addSubview(view)

        sheetView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(view.snp.height).offset(48)
        }

        view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(24)
        }
    }
}
