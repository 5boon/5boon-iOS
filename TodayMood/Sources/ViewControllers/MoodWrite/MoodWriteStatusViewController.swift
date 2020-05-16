//
//  MoodWriteStatusViewController.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/04/20.
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

final class MoodWriteStatusViewController: BaseViewController, View {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    typealias Reactor = MoodWriteViewReactor
    
    private struct Metric {
        static let gradientHeight: CGFloat = 375.0 / UIScreen.main.bounds.width * 241.0
        static let navButtonTop: CGFloat = 46.0
        static let navButtonHeight: CGFloat = 28.0
        
        static let closeLeft: CGFloat = 28.0
        static let doneRight: CGFloat = 28.0
        static let dateTop: CGFloat = 116.0
        static let labelLeft: CGFloat = 62.0
        static let labelRight: CGFloat = 28.0
        static let howFeelTop: CGFloat = 16.0
        
        static let tableHeader: CGFloat = 22.0
        static let tableLeftRight: CGFloat = 40.0
        static let cellHeight: CGFloat = 8.0 + 7.0 + 75.0
    }
    
    private struct Color {
        static let buttonEnable: UIColor = UIColor.white
        static let buttonDisable: UIColor = UIColor.white.alpha(0.5)
        static let label: UIColor = UIColor.white
        static let tableViewBG: UIColor = UIColor.baseBG
    }
    
    private struct Font {
        static let button: UIFont = UIFont.systemFont(ofSize: 17.0)
        static let dateLabel: UIFont = UIFont.systemFont(ofSize: 14.0)
        static let howFeelLabel: UIFont = UIFont.systemFont(ofSize: 20.0)
    }
    
    private struct Reusable {
        static let statusCell = ReusableCell<MoodStatusCell>()
    }
    
    // MARK: Views
    private let gradientView = TopGradientView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.colors = [UIColor.gradientTop, UIColor.gradientBottom]
    }
    
    private let closeButton = UIButton(type: .system).then {
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(Color.buttonEnable, for: .normal)
        $0.setTitleColor(Color.buttonDisable, for: .disabled)
        $0.titleLabel?.font = Font.button
    }
    
    private let dateLabel = UILabel().then {
        $0.font = Font.dateLabel
        $0.textColor = Color.label
        $0.text = "2020년 3월 5일"
    }
    
    private let howFeelLabel = UILabel().then {
        $0.font = Font.howFeelLabel
        $0.textColor = Color.label
        $0.text = "안녕하세요. 제이님\n오늘의 기분은 어떠세요?"
        $0.numberOfLines = 2
    }
    
    private let tableView = UITableView().then {
        $0.backgroundColor = Color.tableViewBG
        $0.separatorStyle = .none
        $0.rowHeight = Metric.cellHeight
        $0.register(Reusable.statusCell)
        $0.tableHeaderView = UIView().then {
            $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: Metric.tableHeader)
        }
        $0.tableFooterView = UIView()
    }
    
    // MARK: Properties
    let pushMoodWriteSummaryViewControllerFactory: () -> MoodWriteSummaryViewController
    
    // MARK: - Initializing
    init(reactor: Reactor,
         pushMoodWriteSummaryViewControllerFactory: @escaping () -> MoodWriteSummaryViewController) {
        defer { self.reactor = reactor }
        self.pushMoodWriteSummaryViewControllerFactory = pushMoodWriteSummaryViewControllerFactory
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
        gradientView.addSubview(closeButton)
        gradientView.addSubview(dateLabel)
        gradientView.addSubview(howFeelLabel)
        
        self.view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        gradientView.snp.makeConstraints { make in
            make.top.left.right.width.equalToSuperview()
            make.height.equalTo(Metric.gradientHeight)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(Metric.navButtonTop)
            make.left.equalTo(Metric.closeLeft)
            make.height.equalTo(Metric.navButtonHeight)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(Metric.dateTop)
            make.left.equalTo(Metric.labelLeft)
            make.right.equalTo(-Metric.labelRight)
        }
        
        howFeelLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Metric.howFeelTop)
            make.left.equalTo(Metric.labelLeft)
            make.right.equalTo(-Metric.labelRight)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(gradientView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)

        // State
        let datasource = dataSource()
        reactor.state.map { $0.statusSection }
            .bind(to: tableView.rx.items(dataSource: datasource))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.selectedStatus }
            .filterNil()
            .distinctUntilChanged()
            .delay(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushToSummary()
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.user }
            .filterNil()
            .subscribe(onNext: { [weak self] user in
                guard let self = self, let userName = user.userName else { return }
                let text = "안녕하세요. \(userName)님\n오늘의 기분은 어떠세요?"
                self.howFeelLabel.text = text
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.writeDate }
            .subscribe(onNext: { [weak self] date in
                guard let self = self else { return }
                let df = DateFormatter()
                df.dateFormat = "yyyy년 M월 d일"
                let writeDate = df.string(from: date)
                self.dateLabel.text = writeDate
            }).disposed(by: self.disposeBag)
        
        // View
        tableView.rx.itemSelected(dataSource: datasource)
            .subscribe(onNext: { sectionItem in
                switch sectionItem {
                case .status(let cellReactor):
                    let status = cellReactor.currentState.status
                    reactor.action.onNext(.selectStatus(status))
                }
            }).disposed(by: self.disposeBag)
    }
    
    private func dataSource() -> RxTableViewSectionedReloadDataSource<MoodStatusSection> {
        return .init(configureCell: { (dataSource, tableView, indexPath, sectionItem) -> UITableViewCell in
            switch sectionItem {
            case .status(let cellReactor):
                let cell = tableView.dequeue(Reusable.statusCell, for: indexPath)
                cell.reactor = cellReactor
                return cell
            }
        })
    }
    
    // MARK: - Route
    private func pushToSummary() {
        let controller = self.pushMoodWriteSummaryViewControllerFactory()
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
