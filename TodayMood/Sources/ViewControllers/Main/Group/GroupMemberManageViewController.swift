//
//  GroupMemberManageViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/06/23.
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

final class GroupMemberManageViewController: BaseViewController, ReactorKit.View {
    
    typealias Reactor = GroupMemberManageViewReactor
    
    private struct Metric {
        static let containerTop: CGFloat = 50.0
        static let containerWidth: CGFloat = UIScreen.main.bounds.width / 3.0 * 2.0
        
        static let countViewHeight: CGFloat = 45.0
        static let countLeftRight: CGFloat = 25.0
        static let underLine: CGFloat = 1.0
        
        static let bottomHeight: CGFloat = 87.0
        static let buttonWidthHeight: CGFloat = 24.0
        static let buttonTop: CGFloat = 14.0
        static let leaveLeft: CGFloat = 25.0
        static let settingRight: CGFloat = 25.0
        static let inviteRight: CGFloat = 14.0
        
        static let cellHeight: CGFloat = 48.0
    }
    
    private struct Color {
        static let dim: UIColor = UIColor.black.alpha(0.7)
        static let count: UIColor = UIColor.groupCountText
        static let underLine: UIColor = UIColor.groupCountText.alpha(0.5)
    }
    
    private struct Font {
        static let count: UIFont = UIFont.systemFont(ofSize: 12.0)
    }
    
    private struct Reusable {
        static let memberCell = ReusableCell<GroupMemberManageCell>()
    }
    
    // MARK: Views
    private let dimView = UIView().then {
        $0.backgroundColor = Color.dim
        $0.alpha = 0.0
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        // $0.alpha = 0.0
    }
    
    private let countBackView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let countLabel = UILabel().then {
        $0.text = "5명 참여중"
        $0.textColor = Color.count
        $0.font = Font.count
    }
    
    private let countUnderLine = UIView().then {
        $0.backgroundColor = Color.underLine
    }
    
    private let bottomBackView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let bottomTopLine = UIView().then {
        $0.backgroundColor = Color.underLine
    }
    
    private let leaveButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left.square"), for: .normal)
    }
    
    private let inviteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "envelope.fill"), for: .normal)
    }
    
    private let settingButton = UIButton().then {
        $0.setImage(UIImage(systemName: "gear"), for: .normal)
    }
    
    private let tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.register(Reusable.memberCell)
        $0.rowHeight = Metric.cellHeight
//        $0.tableFooterView = UIView()
    }
    
    private let tableBottomLine = UIView().then {
        $0.backgroundColor = Color.underLine
        $0.frame = CGRect(x: 0, y: 0,
                          width: Metric.containerWidth,
                          height: 1.0)
    }
    
    // MARK: Properties
    var containerRightToSuperView: Constraint?
    var containerRightOffset: Constraint?
    
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
        self.view.backgroundColor = .clear
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        self.view.addSubview(dimView)
        self.view.addSubview(containerView)
        
        containerView.addSubview(countBackView)
        
        countBackView.addSubview(countUnderLine)
        countBackView.addSubview(countLabel)
        
        containerView.addSubview(tableView)
        tableView.tableFooterView = tableBottomLine
        
        containerView.addSubview(bottomBackView)
        
        bottomBackView.addSubview(bottomTopLine)
        bottomBackView.addSubview(leaveButton)
        bottomBackView.addSubview(inviteButton)
        bottomBackView.addSubview(settingButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(Metric.containerTop)
            containerRightToSuperView = make.right.equalToSuperview().constraint
            containerRightOffset = make.right.equalToSuperview().offset(Metric.containerWidth).constraint
            make.bottom.equalToSuperview()
            make.width.equalTo(Metric.containerWidth)
        }
        
        containerRightOffset?.activate()
        containerRightToSuperView?.deactivate()
        
        countBackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(Metric.countViewHeight)
        }
        
        countUnderLine.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(Metric.underLine)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(Metric.countLeftRight)
            make.right.equalTo(-Metric.countLeftRight)
        }
        
        bottomBackView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(Metric.bottomHeight)
        }
        
        bottomTopLine.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(Metric.underLine)
        }
        
        leaveButton.snp.makeConstraints { make in
            make.top.equalTo(Metric.buttonTop)
            make.width.height.equalTo(Metric.buttonWidthHeight)
            make.left.equalTo(Metric.leaveLeft)
        }
        
        settingButton.snp.makeConstraints { make in
            make.top.equalTo(Metric.buttonTop)
            make.width.height.equalTo(Metric.buttonWidthHeight)
            make.right.equalTo(-Metric.settingRight)
        }
        
        inviteButton.snp.makeConstraints { make in
            make.top.equalTo(Metric.buttonTop)
            make.width.height.equalTo(Metric.buttonWidthHeight)
            make.right.equalTo(settingButton.snp.left).offset(-Metric.inviteRight)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(countBackView.snp.bottom)
            make.bottom.equalTo(bottomBackView.snp.top)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        self.rx.viewDidAppear
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showAnimation()
            }).disposed(by: self.disposeBag)

        self.dimView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.hideAnimation()
            }).disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.groupMembers.count }
            .map { "\($0)명 참여중" }
            .bind(to: countLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        let datasource = dataSource()
        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: datasource))
            .disposed(by: self.disposeBag)
        
        // View
    }
    
    private func dataSource() -> RxTableViewSectionedReloadDataSource<GroupMemberManageSection> {
        return .init(configureCell: { (dataSource, tableView, indexPath, sectionItem) -> UITableViewCell in
            switch sectionItem {
            case .memberList(let cellReactor):
                let cell = tableView.dequeue(Reusable.memberCell, for: indexPath)
                cell.reactor = cellReactor
                return cell
            }
        })
    }
    
    private func showAnimation() {
        guard self.containerView.constraints.isNotEmpty else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.dimView.alpha = 1.0
        })
        
        UIView.animate(withDuration: 0.3, animations: {
            self.containerRightToSuperView?.activate()
            self.containerRightOffset?.deactivate()
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideAnimation() {
        guard self.containerView.constraints.isNotEmpty else { return }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.dimView.alpha = 0.0
        }) { [weak self] finished in
            guard let self = self else { return }
            if finished {
            }
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.containerRightToSuperView?.deactivate()
            self.containerRightOffset?.activate()
            self.view.layoutIfNeeded()
        }) { finished in
             self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    // MARK: - Route
}
