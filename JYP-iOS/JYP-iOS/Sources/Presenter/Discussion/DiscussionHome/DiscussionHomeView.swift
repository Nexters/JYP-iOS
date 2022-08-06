//
//  DiscussionHomeView.swift
//  JYP-iOS
//
//  Created by 송영모 on 2022/08/04.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import UIKit

class DiscussionHomeView: BaseView {
    let dateLabel = UILabel()
    let inviteButton = UIButton()
    let bottomView = UIView()
    let discussionButton = UIButton()
    let planerButton = UIButton()
    let discussionView = UIView()
    let planerView = UIView()
    let discussionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func setupProperty() {
        super.setupProperty()
        
        backgroundColor = JYPIOSAsset.backgroundGrey300.color
        
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
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubviews([dateLabel, inviteButton, bottomView])
        
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
}
