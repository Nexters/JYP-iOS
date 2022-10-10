//
//  DiscussionPlaceMapViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/06.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit
#if targetEnvironment(simulator)
#else
    import GoogleMaps
#endif

class PlannerSearchPlaceMapViewController: NavigationBarViewController, View {
    typealias Reactor = PlannerSearchPlaceMapReactor
    
    // MARK: - UI Components
    
    let topView: UIView = .init()
    let backButton: UIButton = .init(type: .system)
    let searchTextField: JYPSearchTextField = .init(type: .place)
    #if targetEnvironment(simulator)
        lazy var mapView = UIView().then {
            $0.backgroundColor = .systemRed
        }
    #else
        lazy var mapView = GMSMapView(
            frame: view.bounds,
            camera: .camera(
                withLatitude: Double(reactor?.currentState.kakaoSearchPlace.y ?? "") ?? 0.0,
                longitude: Double(reactor?.currentState.kakaoSearchPlace.x ?? "") ?? 0.0,
                zoom: 18
            )
        )
        lazy var marker = GMSMarker(position: .init(latitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude))
    #endif
    
    let bottomView: UIView = .init()
    let titleLabel: UILabel = .init()
    let subLabel: UILabel = .init()
    let infoButton: UIButton = .init()
    let addButton: JYPButton = .init(type: .add)
    
    // MARK: - Initializer
    
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        setNavigationBarHidden(true)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        topView.backgroundColor = JYPIOSAsset.backgroundWhite100.color
        
        backButton.setImage(JYPIOSAsset.iconBack.image, for: .normal)
        backButton.tintColor = JYPIOSAsset.textB90.color
        
        marker.map = mapView
        
        bottomView.backgroundColor = .white
        bottomView.cornerRound(radius: 20, direct: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 24)
        titleLabel.textColor = JYPIOSAsset.textB90.color
        
        subLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
        subLabel.textColor = JYPIOSAsset.textB40.color
        subLabel.numberOfLines = 0
        
        addButton.isEnabled = true
        
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
            $0.trailing.equalTo(infoButton.snp.leading)
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
    
    func bind(reactor: PlannerSearchPlaceMapReactor) {
        let state = reactor.currentState

        searchTextField.textField.text = state.kakaoSearchPlace.placeName
        titleLabel.text = state.kakaoSearchPlace.placeName
        subLabel.text = state.kakaoSearchPlace.addressName
        
        infoButton.rx.tap
            .map { .didTapInfoButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map { .dismiss }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap(\.webReactor)
            .bind { [weak self] reactor in
                let webViewController = WebViewController(reactor: reactor)
                
                self?.tabBarController?.present(webViewController, animated: true)
            }
            .disposed(by: disposeBag)
                
        reactor.state.map(\.isDismiss)
            .filter { $0 }
            .bind { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
