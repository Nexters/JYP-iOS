//
//  CreateProfileBottomSheetViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2023/01/29.
//  Copyright © 2023 JYP-iOS. All rights reserved.
//

import Foundation

import UIKit
import ReactorKit
import RxSwift

class CreateProfileBottomSheetViewController: BottomSheetViewController, View {
    typealias Reactor = CreateProfileBottomSheetReactor
    
    // MARK: - UI Components
    
    let containerView: UIView = .init()
    let titleLabel: UILabel = .init()
    let subLabel: UILabel = .init()
    let profileBox: ProfileBox = .init()
    let defaultProfileBox: ProfileBox = .init()
    let stackView: UIStackView = .init()
    let button: JYPButton = .init(type: .start)
    
    // MARK: - Initializer
    
    init(reactor: Reactor) {
        super.init(mode: .drag)
        
        self.reactor = reactor
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addContentView(view: containerView)
    }
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()
        
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 20)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = JYPIOSAsset.textB80.color
        
        subLabel.text = "사용할 프로필을 선택해주세요"
        subLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 16)
        subLabel.textColor = JYPIOSAsset.textB40.color
        
        stackView.distribution = .equalSpacing
        stackView.spacing = 48
        stackView.alignment = .leading
        
        button.setTitleColor(JYPIOSAsset.textB40.color, for: .normal)
        button.titleLabel?.font = JYPIOSFontFamily.Pretendard.regular.font(size: 16)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        containerView.addSubviews([titleLabel, subLabel, button, stackView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.leading.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(21)
            $0.leading.trailing.equalToSuperview().inset(84)
        }
        
        button.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(6)
            $0.height.equalTo(52)
        }
    }
    
    func bind(reactor: Reactor) {
        rx.viewWillAppear
            .map { _ in
                (UserDefaultsAccess.get(key: .nickname),
                 UserDefaultsAccess.get(key: .personality),
                 UserDefaultsAccess.get(key: .profileImagePath))
            }
            .withUnretained(self)
            .subscribe(onNext: { (this, arg) in
                let (nickname, personality, profileImagePath) = arg
                
                if let nickname = nickname, let personality = personality {
                    this.titleLabel.text = "\(nickname)님은\n\(personality)이시군요!"
                }
                
                this.stackView.removeArrangedSubviews()
                
                if let nickname = nickname, let profileImagePath = profileImagePath {
                    this.profileBox.update(imagePath: profileImagePath, title: nickname)
                    
                    this.stackView.addArrangedSubview(this.profileBox)
                }
                this.stackView.addArrangedSubview(this.defaultProfileBox)
            })
            .disposed(by: disposeBag)
        
        profileBox.rx.tapGesture()
            .when(.recognized)
            .filter { $0.state == .ended }
            .map { _ in .tapProfileBox }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        defaultProfileBox.rx.tapGesture()
            .when(.recognized)
            .filter { $0.state == .ended }
            .map { _ in .tapDefaultProfileBox }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        button.rx.tap
            .map { .tapButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap(\.profileType)
            .subscribe(onNext: { [weak self] type in
                self?.button.isEnabled = true
                
                switch type {
                case .my:
                    self?.profileBox.isSelected = true
                    self?.defaultProfileBox.isSelected = false
                    
                default:
                    self?.profileBox.isSelected = false
                    self?.defaultProfileBox.isSelected = true
                }
            })
            .disposed(by: disposeBag)
    }
}
