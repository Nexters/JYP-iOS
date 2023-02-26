//
//  NavigationBarViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/30.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class NavigationBar: UIView {
    var backButton = UIButton()
    var title = UILabel()
    var subTitle = UILabel()
    var closeButton = UIButton()
}

protocol BaseNavigationBarViewControllerProtocol: AnyObject {
    var statusBar: UIView { get }
    var navigationBar: NavigationBar { get }
    var contentView: UIView { get }
    
    func setupNavigationBar()
    func setNavigationBarBackgroundColor(_ color: UIColor?)
    func setNavigationBarHidden(_ hidden: Bool)
    func setNavigationBarBackButtonHidden(_ hidden: Bool)
    func setNavigationBarBackButtonTintColor(_ color: UIColor)
    func setNavigationBarCloseButtonHidden(_ hidden: Bool)
    func setNavigationBarTitleText(_ text: String?)
    func setNavigationBarTitleFont(_ font: UIFont?)
    func setNavigationBarTitleTextColor(_ color: UIColor?)
    func setNavigationBarSubTitleText(_ text: String?)
    func setNavigationBarSubTitleFont(_ font: UIFont?)
    func setNavigationBarSubTitleTextColor(_ color: UIColor?)
}

class NavigationBarViewController: BaseViewController, BaseNavigationBarViewControllerProtocol {
    // MARK: - UI Components
    
    var statusBar = UIView()
    var navigationBar = NavigationBar()
    var contentView = UIView()
    
    // MARK: - Properties
    
    private let titleFont = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
    private let titleTextColor = JYPIOSAsset.textB75.color
    private let subTitleFont = JYPIOSFontFamily.Pretendard.regular.font(size: 18)
    private let subTitleTextColor = JYPIOSAsset.tagGrey200.color
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    // MARK: - Setup Methods
    
    override func setupProperty() {
        super.setupProperty()

        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        setNavigationBarBackgroundColor(.clear)
        setNavigationBarTitleFont(titleFont)
        setNavigationBarTitleTextColor(titleTextColor)
        setNavigationBarSubTitleFont(subTitleFont)
        setNavigationBarSubTitleTextColor(subTitleTextColor)
        setNavigationBarCloseButtonHidden(true)
        navigationBar.backButton.setImage(JYPIOSAsset.iconBack.image, for: .normal)
        navigationBar.backButton.tintColor = JYPIOSAsset.subBlack.color
        navigationBar.closeButton.setImage(JYPIOSAsset.iconXDelete.image, for: .normal)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([statusBar, navigationBar, contentView])
      
        navigationBar.addSubviews([navigationBar.title, navigationBar.backButton, navigationBar.subTitle, navigationBar.closeButton])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        statusBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(statusBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        navigationBar.backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        navigationBar.title.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(55)
            $0.centerY.equalToSuperview()
        }
        
        navigationBar.subTitle.snp.makeConstraints {
            $0.leading.equalTo(navigationBar.title.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        
        navigationBar.closeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(statusBar.snp.bottom).offset(60)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setupBind() {
        navigationBar.backButton.rx.tap
            .bind { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        navigationBar.closeButton.rx.tap
            .bind { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func setupNavigationBar() { }
    
    func setNavigationBarBackgroundColor(_ color: UIColor?) {
        statusBar.backgroundColor = color
        navigationBar.backgroundColor = color
    }
    
    func setNavigationBarHidden(_ hidden: Bool) {
        navigationBar.isHidden = hidden
        
        if hidden {
            contentView.snp.remakeConstraints {
                $0.top.equalTo(statusBar.snp.bottom)
                $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                $0.bottom.equalToSuperview()
            }
        } else {
            contentView.snp.remakeConstraints {
                $0.top.equalTo(statusBar.snp.bottom).offset(60)
                $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    func setNavigationBarBackButtonHidden(_ hidden: Bool) {
        navigationBar.backButton.isHidden = hidden
        
        if hidden {
            navigationBar.title.snp.updateConstraints {
                $0.leading.equalToSuperview().inset(24)
            }
        }
    }
    
    func setNavigationBarBackButtonTintColor(_ color: UIColor) {
        navigationBar.backButton.setImage(JYPIOSAsset.iconBack.image.withTintColor(color), for: .normal)
    }
    
    func setNavigationBarCloseButtonHidden(_ hidden: Bool) {
        navigationBar.closeButton.isHidden = hidden
    }
    
    func setNavigationBarTitleText(_ text: String?) {
        navigationBar.title.text = text
    }
    
    func setNavigationBarTitleFont(_ font: UIFont?) {
        navigationBar.title.font = font
    }
    
    func setNavigationBarTitleTextColor(_ color: UIColor?) {
        navigationBar.title.textColor = color
    }
    
    func setNavigationBarSubTitleText(_ text: String?) {
        navigationBar.subTitle.text = text
    }
    
    func setNavigationBarSubTitleFont(_ font: UIFont?) {
        navigationBar.subTitle.font = font
    }
    
    func setNavigationBarSubTitleTextColor(_ color: UIColor?) {
        navigationBar.subTitle.textColor = color
    }
}

extension NavigationBarViewController {
    /// pop 네비게이션 함수
    /// - Parameters:
    ///   - viewControllerType: 돌아갈 뷰컨트롤러 타입
    ///   - animated: animation 적용 여부
    func popToViewController(_ viewControllerType: AnyObject.Type, animated: Bool = true) {
        guard let viewController = self.navigationController?.viewControllers.filter({ type(of: $0).isEqual(viewControllerType) }).first else { return }

        self.navigationController?.popToViewController(viewController, animated: animated)
    }
}
