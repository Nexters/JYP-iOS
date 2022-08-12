//
//  CreatePlannerTagViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/07.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import RxDataSources
import UIKit

class CreatePlannerTagViewController: NavigationBarViewController, View {
    typealias Reactor = CreatePlannerTagReactor
    typealias CreateTagDataSource = RxCollectionViewSectionedReloadDataSource<TagSectionModel>

    // MARK: - UI Components

    private let titleLabel: UILabel = .init()
    private let subTitleLabel: UILabel = .init()
    private let startButton: JYPButton = .init(type: .startPlan)

    private let layout: UICollectionViewFlowLayout = .init()
    private lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)

    // MARK: - Properties

    private lazy var dataSource = CreateTagDataSource { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case let .tagCell(tag):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: JourneyTagCollectionViewCell.self),
                for: indexPath
            ) as? JourneyTagCollectionViewCell else { return .init() }
            cell.update(title: tag.text)

            return cell
        }
    } configureSupplementaryView: { dataSource, collectionView, _, indexPath -> UICollectionReusableView in
        let model = dataSource[indexPath.section].model
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: String(describing: PlannerTagCollectionReusableView.self), for: indexPath
        ) as? PlannerTagCollectionReusableView else { return UICollectionReusableView() }
        header.titleLabel.text = model.title
        header.addButton.isHidden = model.isHiddenRightButton

        return header
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

        setNavigationBarBackgroundColor(JYPIOSAsset.backgroundWhite100.color)
        setNavigationBarTitleText("여행 취향 태그")
        setNavigationBarTitleTextColor(JYPIOSAsset.textB80.color)
        setNavigationBarTitleFont(JYPIOSFontFamily.Pretendard.medium.font(size: 16))
    }

    override func setupProperty() {
        super.setupProperty()

        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 24)
        titleLabel.text = "어떤 여행을 하고 싶으신가요?"
        titleLabel.textColor = JYPIOSAsset.textB90.color

        subTitleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 16)
        subTitleLabel.textColor = JYPIOSAsset.textB40.color
        let subTitle = "일행과 공유할 태그를 최대 3개 선택해 주세요"
        let attributedString = NSMutableAttributedString(string: subTitle)
        attributedString.addAttribute(.foregroundColor, value: JYPIOSAsset.textB80.color, range: (subTitle as NSString).range(of: "최대 3개"))
        subTitleLabel.attributedText = attributedString

        layout.scrollDirection = .vertical

        collectionView.register(PlannerTagCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: PlannerTagCollectionReusableView.self))
        collectionView.register(JourneyTagCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: JourneyTagCollectionViewCell.self))
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        contentView.addSubviews([titleLabel, subTitleLabel, collectionView, startButton])
    }

    override func setupLayout() {
        super.setupLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).inset(4)
            make.leading.equalToSuperview().inset(24)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel.snp.leading)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(53)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(startButton.snp.top)
        }

        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(34)
            make.height.equalTo(52)
        }
    }

    // MARK: - Bind Method

    func bind(reactor: Reactor) {
        reactor.state.map(\.sections).asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CreatePlannerTagViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tags = dataSource[indexPath.section].model.items[indexPath.row]

        return CGSize(width: tags.text.size(withAttributes: [NSAttributedString.Key.font: JYPIOSFontFamily.Pretendard.medium.font(size: 16)]).width + 43, height: 32)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> CGSize {
        .init(width: UIScreen.main.bounds.width, height: 41)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        .init(top: 0, left: 0, bottom: 46, right: 0)
    }
}
