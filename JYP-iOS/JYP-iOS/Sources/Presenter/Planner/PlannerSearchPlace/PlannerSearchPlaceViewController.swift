//
//  DiscussionSearchPlaceViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/06.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit
import RxSwift

class PlannerSearchPlaceViewController: NavigationBarViewController {
    let backButton = UIButton(type: .system)
    let searchTextField = JYPSearchTextField(type: .place)
    let searchTableView = UITableView()
    
    private var documents: [Document] = []
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        setNavigationBarHidden(true)
    }
    
    override func setupProperty() {
        super.setupProperty()
        
        backButton.setImage(JYPIOSAsset.iconBack.image, for: .normal)
        backButton.tintColor = JYPIOSAsset.textB90.color
        
        searchTableView.register(PlannerSearchPlaceTableViewCell.self, forCellReuseIdentifier: String(describing: PlannerSearchPlaceTableViewCell.self))
    }
    
    override func setupDelegate() {
        super.setupDelegate()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
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
    
    override func setupBind() {
        super.setupBind()
        
        searchTextField.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind { [weak self] text in
                if text.isEmpty {
                    self?.reloadSearchResultTableView(documents: [])
                } else {
                    self?.fetchDocuments(keyword: text)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchDocuments(keyword: String) {
        let target = SearchAPI.placeSearch(keyword: keyword)
        
        APIService.request(target: target)
            .map(KakaoSearchResponse.self)
            .subscribe { [weak self] response in
                switch response {
                case .success(let data):
                    self?.reloadSearchResultTableView(documents: data.documents)
                case .failure(let error):
                    print("[D] \(error)")
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func reloadSearchResultTableView(documents: [Document]) {
        self.documents = documents
        searchTableView.reloadData()
    }
}

extension PlannerSearchPlaceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlannerSearchPlaceTableViewCell.self), for: indexPath) as? PlannerSearchPlaceTableViewCell else { return UITableViewCell() }
        let data = documents[indexPath.item]
        
        cell.update(title: data.placeName, sub: data.roadAddressName, category: data.categoryGroupName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let discussionPlaceMapVC = PlannerSearchPlaceMapViewController(document: documents[indexPath.item])
        
        navigationController?.pushViewController(discussionPlaceMapVC, animated: true)
    }
}
