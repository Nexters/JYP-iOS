//
//  ScheduledJourneyView.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/08/16.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import RxDataSources
import UIKit

final class ScheduledJourneyView: BaseView, View {
    typealias Reactor = ScheduledJourneyReactor
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<ScheduledJourneySectionModel>

    private let pushPlannerScreen: (_ id: String) -> PlannerViewController
    private let pushSelectionPlannerJoinBottomScreen: () -> SelectionPlannerJoinBottomViewController

    // MARK: - UI Components

    private let layout: UICollectionViewFlowLayout = .init()
    private lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)

    // MARK: - Properties

    private lazy var dataSource = DataSource { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case .empty:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: EmptyJourneyCardCollectionViewCell.self),
                for: indexPath
            ) as? EmptyJourneyCardCollectionViewCell
            else { return .init() }

            cell.makeButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    guard let self,
                          let parentView = self.reactor?.currentState.parentView
                    else { return }

                    let viewController = self.pushSelectionPlannerJoinBottomScreen()
                    parentView.tabBarController?.present(
                        viewController,
                        animated: true
                    )
                })
                .disposed(by: cell.disposeBag)

            return cell
        case let .journey(cellReactor):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: JourneyCardCollectionViewCell.self),
                for: indexPath
            ) as? JourneyCardCollectionViewCell
            else { return .init() }

            cell.reactor = cellReactor
            cell.moreButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    guard let self,
                          let parentView = self.reactor?.currentState.parentView
                    else { return }

                    print(cellReactor.currentState.journey.id)
                })
                .disposed(by: cell.disposeBag)

            return cell
        }
    }

    // MARK: - Initializer

    init(
        reactor: Reactor,
        pushPlannerScreen: @escaping (_ id: String) -> PlannerViewController,
        pushSelectionPlannerJoinBottomScreen: @escaping () -> SelectionPlannerJoinBottomViewController
    ) {
        self.pushPlannerScreen = pushPlannerScreen
        self.pushSelectionPlannerJoinBottomScreen = pushSelectionPlannerJoinBottomScreen
        super.init(frame: .zero)
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupProperty() {
        super.setupProperty()

        layout.scrollDirection = .horizontal

        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(JourneyCardCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: JourneyCardCollectionViewCell.self))
        collectionView.register(EmptyJourneyCardCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: EmptyJourneyCardCollectionViewCell.self))
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        addSubview(collectionView)
    }

    override func setupLayout() {
        super.setupLayout()

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func bind(reactor: ScheduledJourneyReactor) {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)

        collectionView.rx.modelSelected(type(of: dataSource).Section.Item.self)
            .subscribe(onNext: { [weak self] planner in
                guard let self,
                      let parent = self.reactor?.currentState.parentView
                else { return }

                if case let JourneyCardItem.journey(cellReactor) = planner {
                    let id = cellReactor.currentState.journey.id
                    let viewController = self.pushPlannerScreen(id)
                    viewController.hidesBottomBarWhenPushed = true
                    parent.navigationController?.pushViewController(viewController, animated: true)
                }
            })
            .disposed(by: disposeBag)

        reactor.state
            .asObservable()
            .map(\.sections)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension ScheduledJourneyView: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        .init(width: bounds.width - 96, height: bounds.height - 48)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        16
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let item = dataSource[section].items.first else { return .zero }

        switch item {
        case .empty:
            return .init(top: 0, left: 48, bottom: 0, right: 48)
        case .journey:
            return .init(top: 0, left: 24, bottom: 0, right: 24)
        }
    }
}
