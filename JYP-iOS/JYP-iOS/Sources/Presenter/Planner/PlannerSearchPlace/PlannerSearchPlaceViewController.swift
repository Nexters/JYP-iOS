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
    
    let backButton = UIButton(type: .system)
    let searchTextField = JYPSearchTextField(type: .place)
    let searchTableView = UITableView()

    private lazy var dataSource = RxTableViewSectionedReloadDataSource<PlannerSearchPlaceSectionModel> { [weak self] _, tableView, indexPath, item -> UITableViewCell in
        guard let reactor = self?.reactor else { return .init() }
        
        switch item {
        case let .kakaoItem(reactor):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: KakaoSearchPlaceTableViewCell.self), for: indexPath) as? KakaoSearchPlaceTableViewCell else { return .init() }
            
            cell.reactor = reactor
            return cell
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        setNavigationBarHidden(true)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        backButton.setImage(JYPIOSAsset.iconBack.image, for: .normal)
        backButton.tintColor = JYPIOSAsset.textB90.color
        
        searchTableView.register(KakaoSearchPlaceTableViewCell.self, forCellReuseIdentifier: String(describing: KakaoSearchPlaceTableViewCell.self))
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([backButton, searchTextField, searchTableView])
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
    }
    
    func bind(reactor: PlannerSearchPlaceReactor) {
        // Action
        searchTextField.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .map { text in .search(text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchTableView.rx.itemSelected
            .map { .tapKakaoSearchPlaceCell($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map { .dismiss }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map(\.sections).asObservable()
            .bind(to: searchTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map(\.kakaoSearchPlacePresentPlannerSearchPlaceMapViewController).asObservable()
            .withUnretained(self)
            .bind { this, kakaoSearchPlace in
                if let kakaoSearchPlace = kakaoSearchPlace {
                    let plannerSearchPlaceMapViewController = PlannerSearchPlaceMapViewController(reactor: PlannerSearchPlaceMapReactor(state: .init(kakaoSearchPlace: kakaoSearchPlace)))
                    
                    this.navigationController?.pushViewController(plannerSearchPlaceMapViewController, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map(\.dismiss)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { this, bool in
                if bool {
                    this.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
