//
//  SearchPlaceDetailView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/26.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class SearchPlaceDetailNavigationContentView: BaseView {
}

class SearchPlaceDetailView: BaseView {
    var containerView = UIView()
    let addPlaceBox = AddPlaceBox()
    
    func updateMapView(mapView: GMSMapView) {
        containerView.addSubview(mapView)
        
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        addPlaceBox.backgroundColor = .white
        addPlaceBox.layer.cornerRadius = 12
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([containerView, addPlaceBox])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        addPlaceBox.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(31)
            $0.height.equalTo(225)
        }
    }
    
    override func setupBind() {
        super.setupBind()
    }
}
