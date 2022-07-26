//
//  SearchPlaceViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/07/26.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import Foundation
import UIKit

class SearchPlaceViewController: BaseViewController {
    let navigationContentView = SearchPlaceNavigationContentView()
    let contentView = SearchPlaceView()
    
    lazy var navigationBar = NavigationBar(contentView: navigationContentView)
    
    private var documents: [Document] = []
    
    override func setupProperty() {
        super.setupProperty()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func setupDelegate() {
        super.setupDelegate()
        
        contentView.searchResultTableView.delegate = self
        contentView.searchResultTableView.dataSource = self
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        view.addSubviews([navigationBar, contentView])
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
        navigationContentView.searchTextField.rx.text.orEmpty
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
        contentView.searchResultTableView.reloadData()
    }
}

extension SearchPlaceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchPlaceResultTableViewCell.id, for: indexPath) as? SearchPlaceResultTableViewCell else { return UITableViewCell() }
        let data = documents[indexPath.item]
        
        cell.update(title: data.placeName, sub: data.roadAddressName, category: data.categoryGroupName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = documents[indexPath.item]
        
        let searchPlaceDetailViewController = SearchPlaceDetailViewController(document: data)
        navigationController?.pushViewController(searchPlaceDetailViewController, animated: true)
    }
}
