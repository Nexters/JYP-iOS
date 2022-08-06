//
//  DiscussionHomeViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/04.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class DiscussionHomeViewController: NavigationBarViewController {
    let selfView = DiscussionHomeView()
    
    var tags: [String] = ["이", "이소", "이소진", "이소진이", "이소진이소"]
    var places: [String] = ["1", "2", "3", "4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        setNavigationBarBackgroundColor(JYPIOSAsset.backgroundGrey300.color)
        setNavigationBarTitleText("강릉 여행기")
        setNavigationBarTitleTextColor(JYPIOSAsset.textWhite.color)
        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.semiBold.font(size: 20))
    }
    
    override func setupProperty() {
        super.setupProperty()
    }
    
    override func setupDelegate() {
        super.setupDelegate()
        
        selfView.discussionCollectionView.delegate = self
        selfView.discussionCollectionView.dataSource = self
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubview(selfView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        selfView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupBind() {
        super.setupBind()
        
        selfView.inviteButton.rx.tap
            .bind { [weak self] _ in
                let discussionInviteVC = DiscusstionInviteViewController()
                self?.navigationController?.pushViewController(discussionInviteVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

extension DiscussionHomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return tags.count
        case 1:
            return places.isEmpty ? 1 : places.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 24, bottom: 48, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: tags[indexPath.item].size(withAttributes: [NSAttributedString.Key.font: JYPIOSFontFamily.Pretendard.medium.font(size: 16)]).width + 43, height: 32)
        case 1:
            if places.isEmpty {
                return CGSize(width: collectionView.frame.width - 48, height: 327)
            } else {
                return CGSize(width: collectionView.frame.width - 48, height: 165)
            }
            
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            if kind == UICollectionView.elementKindSectionHeader {
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: JourneyTagSectionHeader.self), for: indexPath) as? JourneyTagSectionHeader else { return .init() }
                
                return sectionHeader
            } else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: EmptyCollectionFooterView.self), for: indexPath)
            }
        case 1:
            if kind == UICollectionView.elementKindSectionHeader {
                guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: JourneyPlaceSectionHeader.self), for: indexPath) as? JourneyPlaceSectionHeader else { return .init() }
                
                return sectionHeader
            } else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: EmptyCollectionFooterView.self), for: indexPath)
            }
        default:
            if kind == UICollectionView.elementKindSectionHeader {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: EmptyCollectionHeaderView.self), for: indexPath)
            } else {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: EmptyCollectionFooterView.self), for: indexPath)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: JourneyTagCollectionViewCell.self), for: indexPath) as? JourneyTagCollectionViewCell else { return UICollectionViewCell() }

            cell.update(title: tags[indexPath.item])
            return cell
        case 1:
            if places.isEmpty {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: JourneyPlaceEmptyCollectionViewCell.self), for: indexPath) as? JourneyPlaceEmptyCollectionViewCell else { return UICollectionViewCell() }

                cell.update()
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: JourneyPlaceCollectionViewCell.self), for: indexPath) as? JourneyPlaceCollectionViewCell else { return UICollectionViewCell() }

                cell.update()
                return cell
            }
        default:
            return UICollectionViewCell()
        }
    }
}
