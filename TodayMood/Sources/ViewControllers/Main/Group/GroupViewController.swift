//
//  GroupViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/22.
//

import UIKit

import ReactorKit
import ReusableKit
import RxCocoa
import RxDataSources
import RxSwift
import RxViewController
import SnapKit
import Then

final class GroupViewController: BaseViewController, View {
    
    typealias Reactor = GroupViewReactor
    
    private struct Metric {
        static let cellHeight: CGFloat = 80.0
        static let leftRightMargin: CGFloat = 11.0
        static let topMargin: CGFloat = 16.0
        
    }
    
    private struct Color {
        static let background: UIColor = UIColor.baseBG
        static let refreshControl: UIColor = UIColor.keyColor
    }
    
    private struct Font {
        // static let title = UIFont.systemFont(ofSize: 15.0)
    }
    
    private struct Localized {
        static let title = NSLocalizedString("그룹", comment: "그룹")
    }
    
    private struct Reusable {
        static let groupCell = ReusableCell<PublicGroupCell>()
    }
    
    // MARK: Views
    private let tableView = UITableView().then {
        $0.backgroundColor = Color.background
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 80.0
        $0.rowHeight = UITableView.automaticDimension
        $0.register(Reusable.groupCell)
        $0.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0,
                                                  width: UIScreen.main.bounds.width,
                                                  height: 16.0))
        $0.tableFooterView = UIView(frame: CGRect(x: 0, y: 0,
                                                  width: UIScreen.main.bounds.width,
                                                  height: 50.0))
    }
    
    private let addButton = UIBarButtonItem(image: UIImage(named: "nav_add"), style: .plain, target: nil, action: nil)
    
    private let joinButton = UIBarButtonItem(image: UIImage(systemName: "envelope"), style: .plain, target: nil, action: nil)
    
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
    var presentAddGroupFactory: () -> GroupAddViewController
    var pushGroupDetailFactory: (PublicGroup) -> GroupDetailViewController
    
    // MARK: - Initializing
    init(reactor: Reactor,
         presentAddGroupFactory: @escaping () -> GroupAddViewController,
         pushGroupDetailFactory: @escaping (PublicGroup) -> GroupDetailViewController) {
        defer { self.reactor = reactor }
        self.presentAddGroupFactory = presentAddGroupFactory
        self.pushGroupDetailFactory = pushGroupDetailFactory
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Localized.title
        self.navigationItem.rightBarButtonItems = [addButton, joinButton]
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        self.view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        
        addButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.presentAddGroup()
            }).disposed(by: self.disposeBag)
        
        joinButton.rx.tap
            .flatMap { [weak self] _ -> Observable<String> in
                guard let self = self else { return .empty() }
                return self.presentInvitationAlert()
        }.map {
            Reactor.Action.joinGroup($0)
        }
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
        
        reactor.state.map { $0.groups.isEmpty }
            .subscribe(onNext: { [weak self] isEmpty in
                guard let self = self else { return }
                self.tableView.backgroundView = (isEmpty) ? self.emptyView : nil
            }).disposed(by: self.disposeBag)
        
        let datasource = dataSource()
        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: datasource))
            .disposed(by: self.disposeBag)
        
        // View
        tableView.rx.itemSelected(dataSource: datasource)
            .subscribe(onNext: { [weak self] sectionItem in
                guard let self = self else { return }
                switch sectionItem {
                case .groupList(let cellReactor):
                    // logger.debug(cellReactor.currentState)
                    self.pushToGroupdetail(groupInfo: cellReactor.currentState.group)
                }
            }).disposed(by: self.disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak tableView] indexPath in
                tableView?.deselectRow(at: indexPath, animated: true)
            }).disposed(by: self.disposeBag)
    }
    
    private func dataSource() -> RxTableViewSectionedReloadDataSource<PublicGroupSection> {
        return .init(configureCell: { (dataSource, tableView, indexPath, sectionItem) -> UITableViewCell in
            switch sectionItem {
            case .groupList(let cellReactor):
                let cell = tableView.dequeue(Reusable.groupCell, for: indexPath)
                cell.reactor = cellReactor
                return cell
            }
        })
    }
    
    // MARK: - Route
    private func presentAddGroup() {
        let controller = self.presentAddGroupFactory()
        controller.modalPresentationStyle = .overFullScreen
        controller.view.alpha = 0.9
        self.present(controller, animated: false, completion: nil)
    }
    
    private func presentInvitationAlert() -> Observable<String> {
        
        return Observable.create { observer -> Disposable in
            
            let alert = UIAlertController(title: "그룹참여",
                                          message: "그룹 참여를 위해 코드를 입력해주세요.",
                                          preferredStyle: .alert)
            alert.addTextField { textField in
                textField.enablesReturnKeyAutomatically = true
            }
            
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "참여", style: .default, handler: { _ in
                guard let code = alert.textFields?.first?.text, code.isNotEmpty else {
                    observer.onCompleted()
                    return
                }
                observer.onNext(code)
                observer.onCompleted()
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            return Disposables.create {}
        }
    }
    
    private func pushToGroupdetail(groupInfo: PublicGroup) {
        let controller = self.pushGroupDetailFactory(groupInfo)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
