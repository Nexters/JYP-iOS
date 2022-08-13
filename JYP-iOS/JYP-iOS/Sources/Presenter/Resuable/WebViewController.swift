//
//  WebViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/07.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import WebKit
import ReactorKit

class WebViewController: BaseViewController, View {
    typealias Reactor = WebReactor
    
    let webView = WKWebView()
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        webView.load(.init(url: (.init(string: "dd")!)))
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubview(webView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        webView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind(reactor: WebReactor) {
        let state = reactor.currentState
        
        if let webUrl = URL(string: state.url) {
            webView.load(URLRequest(url: webUrl))
        }
    }
}
