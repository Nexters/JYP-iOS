//
//  Rx+Ext.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/03.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }

    var viewWillAppear: ControlEvent<Bool> {
        let source = methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    var viewDidAppear: ControlEvent<Bool> {
        let source = methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: UITextField {
    /// textField의 focus 이벤트를 제외하고 text 값이 변경될 때 방출된다
    var changedText: ControlProperty<String?> {
        base.rx.controlProperty(
            editingEvents: [.editingChanged, .valueChanged],
            getter: { textField in
                textField.text
            },
            setter: { textField, value in
                if textField.text != value {
                    textField.text = value
                }
            }
        )
    }
}
