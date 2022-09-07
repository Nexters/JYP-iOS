//
//  TagBottomSheetViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/09/07.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class TagBottomSheetViewController: BottomSheetViewController, View {
    typealias Reactor = TagBottomSheetReactor
    
    // MARK: - UI Components
    
    let titleLabel: UILabel = .init()
    let tag: JYPTag = .init()
    
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
        
        
    }
    
    func bind(reactor: Reactor) {
        reactor.state.map(\.users)
        
    }
}
