//
//  MoodWriteGroupListViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/11.
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

final class MoodWriteGroupListViewController: BaseViewController, ReactorKit.View {
    
    typealias Reactor = MoodWriteGroupListViewReactor
    
    private struct Metric {
        static let titleTop: CGFloat = 16.0
        static let textLeftRight: CGFloat = 27.0
        static let descriptionTop: CGFloat = 3.0
        
        static let cellHeight: CGFloat = 48.0
        static let tableViewTop: CGFloat = 15.0
    }
    
    private struct Color {
        static let title: UIColor = UIColor.title
        static let description: UIColor = UIColor.title
        static let tableViewBG: UIColor = UIColor.baseBG
    }
    
    private struct Font {
        static let title: UIFont = UIFont.boldSystemFont(ofSize: 16.0)
        static let description: UIFont = UIFont.systemFont(ofSize: 16.0)
    }
    
    private struct Reusable {
        static let groupCell = ReusableCell<MoodWriteGroupListCell>()
    }
    
    // MARK: Views
    private let titleLabel = UILabel().then {
        $0.textColor = Color.title
        $0.font = Font.title
        $0.text = "오늘의 기분을 공개 할 범위를 설정하세요"
    }
    
    private let descriptionLabel = UILabel().then {
        $0.textColor = Color.description
        $0.font = Font.description
        $0.text = "범위 변경은 작성 후에도 가능합니다"
    }
    
    private let tableView = UITableView().then {
        // $0.backgroundColor = Color.tableViewBG
        $0.separatorStyle = .none
        $0.register(Reusable.groupCell)
        $0.rowHeight = Metric.cellHeight
        $0.tableFooterView = UIView()
    }
    
    private let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: nil, action: nil)
    
    // MARK: Properties
    
    private let selectedGroupsSubject: PublishSubject<[PublicGroup]> = PublishSubject()
    var selectedGroups: Observable<[PublicGroup]> {
        return selectedGroupsSubject.asObservable()
    }
    
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
        self.title = "공개 그룹 선택"
        self.navigationItem.rightBarButtonItem = doneButton
        self.view.backgroundColor = .white
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(descriptionLabel)
        self.view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(Metric.titleTop)
            make.left.equalTo(Metric.textLeftRight)
            make.right.equalTo(-Metric.textLeftRight)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.descriptionTop)
            make.left.equalTo(Metric.textLeftRight)
            make.right.equalTo(-Metric.textLeftRight)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Metric.tableViewTop)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        doneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.selectedGroupsSubject.onNext(reactor.currentState.selectedGroups)
                self.selectedGroupsSubject.onCompleted()
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)
        
        // State
        let dataSource = self.dataSource()
        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.selectedGroups }
            .map { $0.isNotEmpty }
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        // View
        tableView.rx.itemSelected(dataSource: dataSource)
            .subscribe(onNext: { sectionItem in
                switch sectionItem {
                case .group(let cellReactor):
                    reactor.action.onNext(.selectGroup(cellReactor.currentState.group))
                }
            }).disposed(by: self.disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak tableView] indexPath in
                tableView?.deselectRow(at: indexPath, animated: true)
            }).disposed(by: self.disposeBag)
        
    }
    
    private func dataSource() -> RxTableViewSectionedReloadDataSource<MoodWriteGroupSection> {
        return .init(configureCell: { (dataSource, tableView, indexPath, sectionItem) -> UITableViewCell in
            switch sectionItem {
            case .group(let cellReactor):
                let cell = tableView.dequeue(Reusable.groupCell, for: indexPath)
                cell.reactor = cellReactor
                return cell
            }
        })
    }
    
    // MARK: - Route
}
