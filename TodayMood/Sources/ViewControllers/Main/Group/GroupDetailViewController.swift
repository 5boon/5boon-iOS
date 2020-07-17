//
//  GroupDetailViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/06/18.
//

import UIKit

import ReactorKit
import ReusableKit
import RxCocoa
import RxDataSources
import RxSwift
import RxViewController
import SideMenu
import SnapKit
import Then

final class GroupDetailViewController: BaseViewController, ReactorKit.View {
    
    typealias Reactor = GroupDetailViewReactor
    
    private struct Metric {
        // static let topPadding: CGFloat = 16.0
    }
    
    private struct Color {
        static let background: UIColor = UIColor.baseBG
    }
    
    private struct Font {
        // static let title = UIFont.systemFont(ofSize: 15.0)
    }
    
    private struct Reusable {
        static let moodCell = ReusableCell<GroupDetailMoodCell>()
    }
    
    // MARK: Views
    private var menuButton = UIBarButtonItem(image: UIImage(named: "nav_menu"), style: .plain, target: nil, action: nil)
    
    private let tableView = UITableView().then {
        $0.backgroundColor = Color.background
        $0.separatorStyle = .none
        $0.register(Reusable.moodCell)
        $0.estimatedRowHeight = 48.0
        $0.rowHeight =  UITableView.automaticDimension
        $0.tableFooterView = UIView()
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
        self.navigationItem.rightBarButtonItem = menuButton
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
        
        self.menuButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.presentGroupMemberManage()
            }).disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.groupInfo.moodGroup.title }
            .bind(to: self.rx.title)
            .disposed(by: self.disposeBag)
        
        let dataSource = self.dataSource()
        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        // View
        tableView.rx.itemSelected(dataSource: dataSource)
            .subscribe(onNext: { sectionItem in
                switch sectionItem {
                case .groupMood(let cellReactor):
                    logger.debug(cellReactor.currentState)
                }
            }).disposed(by: self.disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak tableView] indexPath in
                tableView?.deselectRow(at: indexPath, animated: true)
            }).disposed(by: self.disposeBag)
    }
    
    private func makeSettings() -> SideMenuSettings {
        
        let presentationStyle = SideMenuPresentationStyle.menuSlideIn
        presentationStyle.backgroundColor = UIColor.red
        
        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = UIScreen.main.bounds.width// / 3.0 * 2.0
        settings.blurEffectStyle = nil
        settings.statusBarEndAlpha = 0.0
        settings.presentDuration = 0.01
//        settings.dismissDuration = 1.0
//        settings.enableTapToDismissGesture = false
        settings.enableSwipeToDismissGesture = false
        return settings
    }
    
    private func dataSource() -> RxTableViewSectionedReloadDataSource<GroupDetailMoodSection> {
        return .init(configureCell: { (dataSource, tableView, indexPath, sectionItem) -> UITableViewCell in
            switch sectionItem {
            case .groupMood(let cellReactor):
                let cell = tableView.dequeue(Reusable.moodCell, for: indexPath)
                cell.reactor = cellReactor
                return cell
            }
        })
    }
    
    // MARK: - Route
    private func presentGroupMemberManage() {
        guard let reactor = self.reactor else { return }
        let controller = GroupMemberManageViewController(reactor: GroupMemberManageViewReactor(groupMembers: reactor.currentState.groupMembers))
        let menu = SideMenuNavigationController(rootViewController: controller)
        menu.settings = makeSettings()
//        menu.presentingViewControllerUserInteractionEnabled = false
        menu.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.rightMenuNavigationController = menu
//        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
//        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        present(menu, animated: true, completion: nil)
    }
    
}
