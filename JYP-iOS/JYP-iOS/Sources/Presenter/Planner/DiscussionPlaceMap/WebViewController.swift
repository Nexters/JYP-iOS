//
//  WebViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/07.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: BaseViewController {
    let url: String
    
    let webView = WKWebView()
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(url: String) {
        self.url = url
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        webView.load(.init(url: (.init(string: url)!)))
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
}
