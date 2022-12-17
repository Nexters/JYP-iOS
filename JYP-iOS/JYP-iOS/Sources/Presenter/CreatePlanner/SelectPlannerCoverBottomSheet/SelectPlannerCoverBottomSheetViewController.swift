//
//  SelectPlannerCoverBottomSheetViewController.swift
//  JYP-iOS
//
//  Created by inae Lee on 2022/09/04.
//  Copyright © 2022 JYP-iOS. All rights reserved.
//

import ReactorKit
import RxDataSources
import UIKit

typealias SelectPlannerCoverSectionModel = SectionModel<Void, PlannerCoverItem>

enum PlannerCoverItem {
    case theme(SelectPlannerCoverCellReactor)
}

class SelectPlannerCoverBottomSheetViewController: BottomSheetViewController, View {
    typealias Reactor = SelectPlannerCoverBottomSheetReactor
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<SelectPlannerCoverSectionModel>

    // MARK: - UI Components

    private let containerView: UIView = .init()

    private let titleLabel: UILabel = .init()
    private let subTitleLabel: UILabel = .init()

    private let layout: UICollectionViewFlowLayout = .init()
    private lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: layout)

    private let submitButton: JYPButton = .init(type: .next)

    // MARK: - Properties

    private lazy var dataSource = DataSource { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case let .theme(cellReactor):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SelectPlannerCoverCollectionViewCell.self), for: indexPath) as? SelectPlannerCoverCollectionViewCell else { return .init() }
            cell.reactor = cellReactor

            return cell
        }
    }

    // MARK: - Initializer

    init(reactor: Reactor) {
        super.init(mode: .drag)
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Setup Methods

    override func setupProperty() {
        super.setupProperty()

        titleLabel.text = "여행기 커버 이미지"
        titleLabel.font = JYPIOSFontFamily.Pretendard.semiBold.font(size: 20)
        titleLabel.textColor = JYPIOSAsset.textB90.color

        subTitleLabel.text = "여행 테마에 맞게 선택해주세요!"
        subTitleLabel.font = JYPIOSFontFamily.Pretendard.regular.font(size: 16)
        subTitleLabel.textColor = JYPIOSAsset.textB40.color

        layout.scrollDirection = .horizontal

        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SelectPlannerCoverCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: SelectPlannerCoverCollectionViewCell.self))
        collectionView.selectItem(at: .init(row: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        collectionView.allowsMultipleSelection = false

        submitButton.isEnabled = true
    }

    override func setupHierarchy() {
        super.setupHierarchy()

        containerView.addSubviews([titleLabel, subTitleLabel, collectionView, submitButton])
        addContentView(view: containerView)
    }

    override func setupLayout() {
        super.setupLayout()

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }

        submitButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(40).priority(.low)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
            make.bottom.equalToSuperview().inset(12)
        }
    }

    // MARK: - Bind

    func bind(reactor: Reactor) {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)

        Observable.zip(
            collectionView.rx.itemSelected,
            collectionView.rx.modelSelected(type(of: self.dataSource).Section.Item.self)
        )
        .map { Reactor.Action.selectTheme($0, $1) }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)

        submitButton.rx.tap
            .map { Reactor.Action.didTapSubmitButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .asObservable()
            .map(\.sections)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        reactor.state
            .map(\.selectedIndexPath)
            .subscribe(onNext: { [weak self] indexPath in
                self?.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map(\.isPushCalendarView)
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                guard let self,
                    let journey = self.reactor?.currentState.journey
                else { return }
                let calendarReactor = CreatePlannerDateReactor(service: CalendarService(), journey: journey)
                let createPlannerDateViewController = CreatePlannerDateViewController(reactor: calendarReactor)

                guard let presentingViewContoller = self.presentingViewController as? UINavigationController else { return }
                self.dismiss(animated: true, completion: {
                    presentingViewContoller
                        .pushViewController(createPlannerDateViewController, animated: true)
                })
            })
            .disposed(by: disposeBag)
    }
}

extension SelectPlannerCoverBottomSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        .init(
            width: (375.0 * 96.0) / UIScreen.main.bounds.width,
            height: (812.0 * 140.0) / UIScreen.main.bounds.height
        )
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        12
    }
}
