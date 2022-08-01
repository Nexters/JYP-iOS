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
}

protocol BaseNavigationBarViewControllerProtocol: AnyObject {
    var statusBar: UIView { get }
    var navigaionBar: NavigationBar { get }
    var contentView: UIView { get }
    
    func setupNavigationBar()
    func setNavigationBarHidden(_ hidden: Bool)
    func setNavigationBarBackButtonHidden(_ hidden: Bool)
    func setNavigationBarBackButtonTitleColor(_ color: UIColor?)
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
    var navigaionBar = NavigationBar()
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
        setNavigationBarTitleFont(titleFont)
        setNavigationBarTitleTextColor(titleTextColor)
        setNavigationBarSubTitleFont(subTitleFont)
        setNavigationBarSubTitleTextColor(subTitleTextColor)
        navigaionBar.backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([statusBar, navigaionBar, contentView])
      
        navigaionBar.addSubviews([navigaionBar.title, navigaionBar.backButton, navigaionBar.subTitle])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        statusBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        navigaionBar.snp.makeConstraints {
            $0.top.equalTo(statusBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        navigaionBar.backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        navigaionBar.title.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(55)
            $0.centerY.equalToSuperview()
        }
        
        navigaionBar.subTitle.snp.makeConstraints {
            $0.leading.equalTo(navigaionBar.title.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(navigaionBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupNavigationBar() { }
    
    func setNavigationBarHidden(_ hidden: Bool) {
        statusBar.isHidden = hidden
        navigaionBar.isHidden = hidden
    }
    
    func setNavigationBarBackButtonHidden(_ hidden: Bool) {
        navigaionBar.backButton.isHidden = hidden
        
        if hidden {
            navigaionBar.title.snp.updateConstraints {
                $0.leading.equalToSuperview().inset(24)
            }
        }
    }
    
    func setNavigationBarBackButtonTitleColor(_ color: UIColor?) {
        navigaionBar.backButton.setTitleColor(color, for: .normal)
    }
    
    func setNavigationBarTitleText(_ text: String?) {
        navigaionBar.title.text = text
    }
    
    func setNavigationBarTitleFont(_ font: UIFont?) {
        navigaionBar.title.font = font
    }
    
    func setNavigationBarTitleTextColor(_ color: UIColor?) {
        navigaionBar.title.textColor = color
    }
    
    func setNavigationBarSubTitleText(_ text: String?) {
        navigaionBar.subTitle.text = text
    }
    
    func setNavigationBarSubTitleFont(_ font: UIFont?) {
        navigaionBar.subTitle.font = font
    }
    
    func setNavigationBarSubTitleTextColor(_ color: UIColor?) {
        navigaionBar.subTitle.textColor = color
    }
}
