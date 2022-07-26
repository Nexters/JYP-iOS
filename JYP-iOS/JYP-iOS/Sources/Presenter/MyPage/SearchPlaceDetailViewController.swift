//
//  SearchPlaceDetailViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/26.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation

class SearchPlaceDetailViewController: BaseViewController {
    let document: Document
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(document: Document) {
        self.document = document
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func setupProperty() {
        super.setupProperty()
    }
    
    override func setupDelegate() {
        super.setupDelegate()
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
    }
    
    override func setupLayout() {
        super.setupLayout()
    }
    
    override func setupBind() {
        super.setupBind()
    }
}
