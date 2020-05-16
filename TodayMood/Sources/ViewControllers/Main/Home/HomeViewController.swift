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
        
        static let timeLineLeft: CGFloat = 44.0
        static let timeLineTop: CGFloat = 23.0
        
        static let shareButtonRight: CGFloat = 37.0
        static let shareButtonTop: CGFloat = 37.0
        static let shareButtonWidthHeight: CGFloat = 24.0
        
        static let dateTop: CGFloat = 2.0
        static let dateLeft: CGFloat = 44.0
        static let dateRight: CGFloat = 12.0
        
        static let tableViewTop: CGFloat = 10.0
    }
    
    private struct Color {
        static let background: UIColor = UIColor.baseBG
        static let refreshControl: UIColor = UIColor.keyColor
        static let timeLine: UIColor = UIColor.keyColor
        static let date: UIColor = UIColor.title
    }
    
    private struct Font {
        static let timeLine: UIFont = UIFont.systemFont(ofSize: 13.0)
        static let date: UIFont = UIFont.systemFont(ofSize: 20.0)
    }
    
    private struct Reusable {
        static let timeLineCell = ReusableCell<HomeTimeLineCell>()
    }
    
    // MARK: Views
    private let gradientView = TopGradientView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.colors = [UIColor.gradientTop, UIColor.gradientBottom]
    }
    
    private let timeLineLabel = UILabel().then {
        $0.font = Font.timeLine
        $0.textColor = Color.timeLine
        $0.text = "timeline"
    }
    
    private let dateLabel = UILabel().then {
        $0.font = Font.date
        $0.textColor = Color.date
        $0.text = "3월 4일의 기분"
    }
    
    private let shareButton = EMTNeumorphicButton(type: .custom).then {
        $0.setImage(UIImage(named: "timeline_share"), for: .normal)
        $0.neumorphicLayer?.elementBackgroundColor = Color.background.cgColor
        $0.neumorphicLayer?.cornerRadius = Metric.shareButtonWidthHeight / 2.0
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
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        
        self.view.addSubview(gradientView)
        self.view.addSubview(timeLineLabel)
        self.view.addSubview(shareButton)
        self.view.addSubview(dateLabel)
        self.view.addSubview(tableView)
        tableView.refreshControl = refreshControl
        self.view.addSubview(loadingIndicator)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        gradientView.snp.makeConstraints { make in
            make.top.left.right.width.equalToSuperview()
            make.height.equalTo(Metric.gradientHeight)
        }
        
        timeLineLabel.snp.makeConstraints { make in
            make.left.equalTo(Metric.timeLineLeft)
            make.top.equalTo(gradientView.snp.bottom).offset(Metric.timeLineTop)
        }
        
        shareButton.snp.makeConstraints { make in
            make.width.height.equalTo(Metric.shareButtonWidthHeight)
            make.right.equalTo(-Metric.shareButtonRight)
            make.top.equalTo(gradientView.snp.bottom).offset(Metric.shareButtonTop)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLineLabel.snp.bottom).offset(Metric.dateTop)
            make.left.equalTo(Metric.dateLeft)
            make.right.lessThanOrEqualTo(shareButton.snp.left).offset(-Metric.dateRight)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Metric.tableViewTop)
            make.left.right.bottom.equalToSuperview()
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
        
        reactor.state.map { $0.moods }
            .subscribe(onNext: { list in
                // logger.debug(list)
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
    
    // MARK: - Route
}
