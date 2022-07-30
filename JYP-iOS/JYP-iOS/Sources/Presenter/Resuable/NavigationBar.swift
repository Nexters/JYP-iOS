////
////  NavigationBar.swift
////  JYP-iOS
////
////  Created by 송영모 on 2022/07/26.
////  Copyright © 2022 JYP-iOS. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class NavigationBar: BaseView {
//    let statusBar = UIView()
//    let backButton = UIButton(type: .system)
//    let containerView = UIView()
//    let contentView: UIView
//    
//    required init?(coder: NSCoder) {
//        fatalError("not supported")
//    }
//    
//    init(contentView: UIView) {
//        self.contentView = contentView
//        
//        super.init(frame: .zero)
//    }
//    
//    override func setupProperty() {
//        super.setupProperty()
//        
//        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
//    }
//    
//    override func setupHierarchy() {
//        super.setupHierarchy()
//        
//        addSubviews([statusBar, backButton, containerView])
//        containerView.addSubview(contentView)
//    }
//    
//    override func setupLayout() {
//        super.setupLayout()
//        
//        statusBar.snp.makeConstraints {
//            $0.top.leading.trailing.equalToSuperview()
//            $0.height.equalTo(44)
//        }
//        
//        backButton.snp.makeConstraints {
//            $0.leading.equalToSuperview().inset(20)
//            $0.centerY.equalTo(contentView)
//        }
//        
//        containerView.snp.makeConstraints {
//            $0.top.equalTo(statusBar.snp.bottom)
//            $0.leading.equalTo(backButton.snp.trailing)
//            $0.trailing.equalToSuperview()
//            $0.bottom.equalToSuperview()
//            $0.height.equalTo(60)
//        }
//        
//        contentView.snp.makeConstraints {
//            $0.top.leading.trailing.bottom.equalToSuperview()
//        }
//    }
//}
