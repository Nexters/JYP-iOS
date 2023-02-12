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

class WebViewController: NavigationBarViewController, View {
    typealias Reactor = WebReactor
    
    let webView: WKWebView = .init()
    let indicator: UIActivityIndicatorView = .init(style: .medium)
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    override func setupDelegate() {
        super.setupDelegate()
        
        webView.navigationDelegate = self
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([webView, indicator])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        webView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func bind(reactor: WebReactor) {
        setNavigationBarHidden(reactor.currentState.navigationBarHidden)
        setNavigationBarBackButtonHidden(reactor.currentState.navigationBarHidden)
        
        if let webUrl = URL(string: reactor.currentState.url) {
            webView.load(URLRequest(url: webUrl))
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
}
