//
//  DiscussionSearchPlaceViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/06.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import ReactorKit

class PlannerSearchPlaceViewController: NavigationBarViewController, View {
    typealias Reactor = PlannerSearchPlaceReactor
    typealias DataSource = RxTableViewSectionedReloadDataSource<PlannerSearchPlaceSectionModel>
    
    // MARK: - UI Components
    
    let backButton: UIButton = .init(type: .system)
    let searchTextField: JYPSearchTextField = .init(type: .place)
    let searchTableView: UITableView = .init()
    let emptyView: UIView = .init()
    let emptyImageView: UIImageView = .init()
    let emptyLabel: UILabel = .init()
  
    // MARK: - Properties

    private lazy var dataSource = DataSource { [weak self] _, tableView, indexPath, item -> UITableViewCell in
        guard let reactor = self?.reactor else { return .init() }
        
        switch item {
        case let .kakaoItem(reactor):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: KakaoSearchPlaceTableViewCell.self), for: indexPath) as? KakaoSearchPlaceTableViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
        }
    }
    
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
        
        backButton.setImage(JYPIOSAsset.iconBack.image, for: .normal)
        backButton.tintColor = JYPIOSAsset.textB90.color
        
        searchTableView.register(KakaoSearchPlaceTableViewCell.self, forCellReuseIdentifier: String(describing: KakaoSearchPlaceTableViewCell.self))
        
        emptyImageView.image = JYPIOSAsset.searchPlaceIllust.image
        
        emptyLabel.numberOfLines = 2
        emptyLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 16)
        emptyLabel.textColor = JYPIOSAsset.textB75.color
        emptyLabel.text = "등록할 장소를\n검색해 주세요!"
        
        emptyView.isHidden = false
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([backButton, searchTextField, searchTableView, emptyView])
        emptyView.addSubviews([emptyImageView, emptyLabel])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
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
        
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        
        emptyImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Bind Method
    
    func bind(reactor: Reactor) {
        searchTextField.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { text in .search(text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchTableView.rx.itemSelected
            .map { .selectCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .withUnretained(self)
            .bind { this, _ in
                this.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.sections)
            .bind(to: searchTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.emptyViewState)
            .withUnretained(self)
            .bind { this, state in
                switch state {
                case .empty:
                    this.emptyImageView.image = JYPIOSAsset.searchPlaceIllust.image
                    this.emptyLabel.text = "등록할 장소를\n검색해주세요!"
                    this.emptyView.isHidden = false
                case .noResult:
                    this.emptyImageView.image = JYPIOSAsset.illust1.image
                    this.emptyLabel.text = "해당 장소를 찾을 수 없어요!"
                    this.emptyView.isHidden = false
                case .none:
                    this.emptyView.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap(\.plannerSearchPlaceMapReactor)
            .withUnretained(self)
            .bind { this, reactor in
                this.navigationController?.pushViewController(PlannerSearchPlaceMapViewController(reactor: reactor), animated: true)
            }
            .disposed(by: disposeBag)
    }
}
