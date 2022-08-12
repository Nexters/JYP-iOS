//
//  DiscussionPlaceMapViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/06.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
#if arch(x86_64)
    import GoogleMaps
#endif

class PlannerSearchPlaceMapViewController: NavigationBarViewController {
    let document: Document
    
    let topView = UIView()
    let backButton = UIButton(type: .system)
    let searchTextField = JYPSearchTextField(type: .place)
    #if arch(x86_64)
        lazy var mapView = GMSMapView(frame: view.bounds, camera: .camera(withLatitude: Double(document.y) ?? 0.0, longitude: Double(document.x) ?? 0.0, zoom: 18))
    #else
        lazy var mapView = UIView().then {
            $0.backgroundColor = .systemRed
        }
    #endif
    
    let bottomView = UIView()
    let titleLabel = UILabel()
    let subLabel = UILabel()
    let infoButton = UIButton()
    let addButton = JYPButton(type: .add)
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(document: Document) {
        self.document = document
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        setNavigationBarHidden(true)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        topView.backgroundColor = JYPIOSAsset.backgroundWhite100.color
        
        backButton.setImage(JYPIOSAsset.iconBack.image, for: .normal)
        backButton.tintColor = JYPIOSAsset.textB90.color
        
        searchTextField.textField.text = document.placeName
        
        bottomView.backgroundColor = .white
        bottomView.cornerRound(radius: 20, direct: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        titleLabel.text = document.placeName
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 24)
        titleLabel.textColor = JYPIOSAsset.textB90.color
        
        subLabel.text = document.addressName
        subLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
        subLabel.textColor = JYPIOSAsset.textB40.color
        
        addButton.isEnabled = false
        
        infoButton.setImage(JYPIOSAsset.iconInfo.image, for: .normal)
        infoButton.setTitle("정보 보기", for: .normal)
        infoButton.setTitleColor(JYPIOSAsset.textB80.color, for: .normal)
        infoButton.titleLabel?.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        infoButton.cornerRound(radius: 8)
        infoButton.backgroundColor = JYPIOSAsset.textWhite.color
        infoButton.setShadow(radius: 12, offset: .init(width: 2, height: 2), opacity: 0.1)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([mapView, topView, bottomView])
        topView.addSubviews([backButton, searchTextField])
        bottomView.addSubviews([titleLabel, subLabel, infoButton, addButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(24)
        }
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalTo(backButton)
            $0.height.equalTo(38)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(24)
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(24)
        }
        
        infoButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(32)
            $0.bottom.equalTo(addButton.snp.top).offset(-28)
            $0.width.equalTo(114)
            $0.height.equalTo(40)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(68)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(34)
            $0.height.equalTo(52)
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
        infoButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                let webVC = PlannerSearchPlaceWebViewController(url: this.document.placeURL)
                this.present(webVC, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}
