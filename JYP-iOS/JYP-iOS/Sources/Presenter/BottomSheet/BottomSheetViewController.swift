//
//  BottomSheetViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/07/28.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxGesture
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

    override func setupBind() {
        sheetView.rx.panGesture()
            .subscribe(onNext: { [weak self] gesture in
                let translation = gesture.translation(in: self?.view)
                print("Pan gesture y offset: \(translation.y)")

                switch gesture.state {
                case .changed: self?.willTransition(to: translation.y)
                case .ended: self?.endTransition(at: translation.y)
                default: break
                }
            })
            .disposed(by: disposeBag)
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

    // MARK: - Dismiss Sheet

    func willTransition(to transitionY: CGFloat) {
        guard transitionY > 0 else { return }

        sheetView.transform = CGAffineTransform(translationX: 0, y: transitionY)
    }

    func endTransition(at transitionY: CGFloat) {
        if transitionY < sheetView.bounds.height / 3.0 {
            sheetView.transform = .identity
        } else {
            dimmedView.backgroundColor = UIColor.clear
            dismiss(animated: true, completion: nil)
        }
    }
}
