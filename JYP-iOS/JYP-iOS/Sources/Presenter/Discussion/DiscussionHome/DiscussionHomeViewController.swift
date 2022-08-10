//
//  DiscussionHomeViewController.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/04.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class DiscussionHomeViewController: NavigationBarViewController {
    let dateLabel = UILabel()
    let inviteButton = UIButton()
    let bottomView = UIView()
    let discussionButton = UIButton()
    let planerButton = UIButton()
    let discussionView = UIView()
    let planerView = UIView()
    let discussionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var tags: [String] = ["이", "이소", "이소진", "이소진이", "이소진이소"]
//    var places: [String] = ["1", "2", "3", "4"]
    var places: [String] = []
    
    override func setupProperty() {
        super.setupProperty()
        
        view.backgroundColor = JYPIOSAsset.backgroundGrey300.color
        
        dateLabel.text = "7월 18일 - 7월 20일"
        dateLabel.font = JYPIOSFontFamily.Pretendard.medium.font(size: 16)
        dateLabel.textColor = JYPIOSAsset.textWhite.color
        
        inviteButton.setTitle("일행 초대하기", for: .normal)
        inviteButton.setTitleColor(.white, for: .normal)
        inviteButton.titleLabel?.font = JYPIOSFontFamily.Pretendard.regular.font(size: 14)
        inviteButton.backgroundColor = JYPIOSAsset.mainPink.color
        inviteButton.setImage(JYPIOSAsset.inviteFriend.image, for: .normal)
        inviteButton.cornerRound(radius: 10)
        
        bottomView.backgroundColor = JYPIOSAsset.backgroundWhite100.color
        bottomView.cornerRound(radius: 20, direct: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        discussionButton.setTitle("토론장", for: .normal)
        discussionButton.setTitleColor(JYPIOSAsset.textB80.color, for: .normal)
        discussionButton.titleLabel?.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 18)
        
        planerButton.setTitle("여행 계획", for: .normal)
        planerButton.setTitleColor(JYPIOSAsset.textB80.color, for: .normal)
        planerButton.titleLabel?.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 18)
        
        discussionCollectionView.showsVerticalScrollIndicator = false
        discussionCollectionView.register(JourneyTagCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: JourneyTagCollectionViewCell.self))
        discussionCollectionView.register(JourneyPlaceCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: JourneyPlaceCollectionViewCell.self))
        discussionCollectionView.register(JourneyPlaceEmptyCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: JourneyPlaceEmptyCollectionViewCell.self))
        discussionCollectionView.register(JourneyTagSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: JourneyTagSectionHeader.self))
        discussionCollectionView.register(JourneyPlaceSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: JourneyPlaceSectionHeader.self))
        discussionCollectionView.register(EmptyCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: EmptyCollectionHeaderView.self))
        discussionCollectionView.register(EmptyCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: EmptyCollectionFooterView.self))
    }
    
    override func setupDelegate() {
        super.setupDelegate()
        
        discussionCollectionView.delegate = self
        discussionCollectionView.dataSource = self
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        contentView.addSubviews([dateLabel, inviteButton, bottomView])
        
        bottomView.addSubviews([discussionButton, planerButton, discussionView])
        
        discussionView.addSubview(discussionCollectionView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        
        inviteButton.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(133)
            $0.height.equalTo(40)
        }
        
        bottomView.snp.makeConstraints {
            $0.top.equalTo(inviteButton.snp.bottom).offset(13)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        discussionButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(24)
        }
        
        planerButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalTo(discussionButton.snp.trailing).offset(28)
        }
        
        discussionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(61)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        discussionCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        setNavigationBarBackgroundColor(JYPIOSAsset.backgroundGrey300.color)
        setNavigationBarTitleText("강릉 여행기")
        setNavigationBarTitleTextColor(JYPIOSAsset.textWhite.color)
        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.semiBold.font(size: 20))
    }
    
    override func setupBind() {
        super.setupBind()
        
        inviteButton.rx.tap
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
                cell.addPlaceButton.rx.tap
                    .bind { [weak self] _ in
                        let discussionSearchPlaceVC = DiscussionSearchPlaceViewController()
                        self?.navigationController?.pushViewController(discussionSearchPlaceVC, animated: true)
                        
                    }
                    .disposed(by: cell.disposeBag)
                
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
            return
        default:
            return
        }
    }
}
