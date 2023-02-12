//
//  MyPageViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/20.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import ReactorKit

class MyPageViewController: NavigationBarViewController, View {
    // MARK: - Properties
    
    typealias Reactor = MyPageReactor
    
    private let pushOnboardingScreen: (() -> OnboardingOneViewController)?
    private let pushWebViewScreen: (_ url: String) -> WebViewController
    private let pushLogoutBottomSheetScreen: () -> LogoutBottomSheetViewController
    private let pushWithdrawBottomSheetScreen: () -> WithdrawBottomSheetViewController
    
    private lazy var logoutBottomSheetViewController = pushLogoutBottomSheetScreen()
    private lazy var withdrawBottomSheetViewController = pushWithdrawBottomSheetScreen()
    
    // MARK: - UI Components
    
    let headerView: UIView = .init()
    let profileImageView: UIImageView = .init()
    let personalityLabel: UILabel = .init()
    let nicknameLabel: UILabel = .init()
    
    let stackView: UIStackView = .init()
    
    let noticeButton: MyPageButton = .init(title: "앱 소식 및 설명서")
    let versionButton: MyPageButton = .init(title: "버전정보", info: Environment.version)
    let logoutButton: MyPageButton = .init(title: "로그아웃")
    let withdrawButton: MyPageButton = .init(title: "회원탈퇴")
    
    // MARK: - Initializer
    
    init(reactor: Reactor,
         pushWebViewScreen: @escaping () -> WebViewController,
         pushOnboardingScreen: @escaping () -> OnboardingOneViewController,
         pushLogoutBottomSheetScreen: @escaping () -> LogoutBottomSheetViewController,
         pushWithdrawBottomSheetScreen: @escaping () -> WithdrawBottomSheetViewController) {
        self.pushOnboardingScreen = pushOnboardingScreen
        self.pushLogoutBottomSheetScreen = pushLogoutBottomSheetScreen
        self.pushWithdrawBottomSheetScreen = pushWithdrawBottomSheetScreen
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
        
        setNavigationBarTitleText("마이페이지")
        setNavigationBarTitleTextColor(JYPIOSAsset.textB75.color)
        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.medium.font(size: 16))
        setNavigationBarBackgroundColor(JYPIOSAsset.backgroundWhite100.color)
        setNavigationBarBackButtonHidden(true)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        view.backgroundColor = JYPIOSAsset.backgroundWhite200.color
        
        headerView.backgroundColor = JYPIOSAsset.backgroundWhite100.color
        headerView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        profileImageView.image = JYPIOSAsset.profile2.image
        
        personalityLabel.numberOfLines = 1
        personalityLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 22)
        personalityLabel.lineSpacing(lineHeight: 34.1)
        personalityLabel.textAlignment = .center
        personalityLabel.textColor = JYPIOSAsset.textB90.color
        
        nicknameLabel.numberOfLines = 1
        nicknameLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        nicknameLabel.lineSpacing(lineHeight: 24)
        nicknameLabel.textAlignment = .center
        nicknameLabel.textColor = JYPIOSAsset.textB80.color
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 12.0
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        [noticeButton, versionButton, logoutButton, withdrawButton].forEach { stackView.addArrangedSubview($0) }
        
        contentView.addSubviews([headerView, profileImageView, personalityLabel, nicknameLabel, stackView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(nicknameLabel.snp.bottom).offset(30).priority(.high)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.size.equalTo(88)
        }
        
        personalityLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(personalityLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    func bind(reactor: Reactor) {
        rx.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.personalityLabel.text = UserDefaultsAccess.get(key: .personality)
                self?.nicknameLabel.text = UserDefaultsAccess.get(key: .nickname)
            })
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.tabBarController?.present(this.logoutBottomSheetViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        withdrawButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.tabBarController?.present(this.withdrawBottomSheetViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap(\.dismissType)
            .withUnretained(self)
            .subscribe(onNext: { this, type in
                switch type {
                case .logout:
                    this.logoutBottomSheetViewController.dismiss(animated: true, completion: {
                        this.willPresentOnboardingOneViewController()
                    })
                case .withdraw:
                    this.withdrawBottomSheetViewController.dismiss(animated: true, completion: {
                        this.willPresentOnboardingOneViewController()
                    })
                }
            })
            .disposed(by: disposeBag)
    }
}

extension MyPageViewController {
    private func willPresentOnboardingOneViewController() {
        if let viewController = pushOnboardingScreen?().navigationWrap() {
            viewController.modalPresentationStyle = .fullScreen
            tabBarController?.present(viewController, animated: true)
        }
    }
    
    private func willPresentWebViewController(url: String) {
        let viewController = pushWebViewScreen(url)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
