//
//  HomeViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/22.
//

import UIKit

import EMTNeumorphicView
import ReactorKit
import ReusableKit
import RxCocoa
import RxDataSources
import RxSwift
import RxViewController
import SnapKit
import Then

final class HomeViewController: BaseViewController, ReactorKit.View {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    typealias Reactor = HomeViewReactor
    
    private struct Metric {
        static let gradientHeight: CGFloat = 375.0 / UIScreen.main.bounds.width * 241.0
        static let tableHeaderHeight: CGFloat = 75.0
    }
    
    private struct Color {
        static let background: UIColor = UIColor.baseBG
        static let refreshControl: UIColor = UIColor.keyColor
    }
    
    private struct Font {
        
    }
    
    private struct Reusable {
        static let timeLineCell = ReusableCell<HomeTimeLineCell>()
    }
    
    // MARK: Views
    private let gradientView = HomeGradientView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.colors = [UIColor.gradientTop, UIColor.gradientBottom]
    }
    
    private let tableHeaderView = TimeLineHeaderView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let tableView = UITableView().then {
        $0.backgroundColor = Color.background
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 80.0
        $0.rowHeight = UITableView.automaticDimension
        $0.register(Reusable.timeLineCell)
        $0.tableFooterView = UIView(frame: CGRect(x: 0, y: 0,
                                                  width: UIScreen.main.bounds.width,
                                                  height: 50.0))
    }
    
    private let refreshControl = UIRefreshControl().then {
        $0.tintColor = Color.refreshControl
    }
    
    private let loadingIndicator = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
    }
    
    private let emptyView = CommonEmptyView().then {
        $0.type = .homeMood
    }
    
    // MARK: Properties
    
    // MARK: - Initializing
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotifications()
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        
        self.view.addSubview(gradientView)
        self.view.addSubview(tableView)
        tableView.tableHeaderView = tableHeaderView
        tableView.refreshControl = refreshControl
        self.view.addSubview(loadingIndicator)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        gradientView.snp.makeConstraints { make in
            make.top.left.right.width.equalToSuperview()
            make.height.equalTo(Metric.gradientHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(gradientView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableHeaderView.snp.makeConstraints { make in
            make.width.equalTo(tableView.snp.width)
            make.height.equalTo(Metric.tableHeaderHeight)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        self.rx.viewDidLoad
            .map { Reactor.Action.firstLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isRefreshing }
            .distinctUntilChanged()
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.tableView.setContentOffset(.zero, animated: false)
                }
            })
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.moods.isEmpty }
            .subscribe(onNext: { [weak self] isEmpty in
                guard let self = self else { return }
                self.tableView.backgroundView = (isEmpty) ? self.emptyView : nil
            }).disposed(by: self.disposeBag)
        
        let datasource = dataSource()
        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: datasource))
            .disposed(by: self.disposeBag)
        
        // View
        tableView.rx.isReachedBottom
            .map { Reactor.Action.loadMore }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        tableView.rx.itemSelected(dataSource: datasource)
            .subscribe(onNext: { [weak self] sectionItem in
                guard let self = self else { return }
                switch sectionItem {
                case .timeLine(let cellReactor):
                    logger.debug(cellReactor.currentState.mood)
                }
            }).disposed(by: self.disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak tableView] indexPath in
                tableView?.deselectRow(at: indexPath, animated: true)
            }).disposed(by: self.disposeBag)
        
        //        tableView.rx.setDelegate(self)
        //            .disposed(by: self.disposeBag)
        
        // SubReactor
        bindGradientReactor(reactor: reactor)
        bindTimeLineHeaderReactor(reactor: reactor)
    }
    
    private func bindGradientReactor(reactor: Reactor) {
        gradientView.reactor = reactor.homeGradientViewReactor
        
        gradientView.rx.prevTapped
            .map { _ in Reactor.Action.movePrev }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        gradientView.rx.nextTapped
            .map { _ in Reactor.Action.moveNext }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        gradientView.rx.prevGesture
            .map { _ in Reactor.Action.movePrev }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        gradientView.rx.nextGesture
            .map { _ in Reactor.Action.moveNext }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
    
    private func bindTimeLineHeaderReactor(reactor: Reactor) {
        tableHeaderView.reactor = reactor.homeTimeLineHeaderViewReactor
    }
    
    private func dataSource() -> RxTableViewSectionedReloadDataSource<TimeLineSection> {
        return .init(configureCell: { (dataSource, tableView, indexPath, sectionItem) -> UITableViewCell in
            switch sectionItem {
            case .timeLine(let cellReactor):
                let cell = tableView.dequeue(Reusable.timeLineCell, for: indexPath)
                cell.reactor = cellReactor
                return cell
            }
        })
    }
    
    // MARK: - Notification
    private func addNotifications() {
        NotificationCenter.default.rx.notification(.createMoodFinished)
            .subscribe(onNext: { [weak self] noti in
                guard let self = self,
                    let reactor = self.reactor,
                    let mood = noti.object as? Mood else { return }
                reactor.action.onNext(.createdMoodInsert(mood))
            }).disposed(by: self.disposeBag)
    }
    
    // MARK: - Route
}
