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
import RxSwift
import RxViewController
import SnapKit
import Then

final class GroupDetailViewController: BaseViewController, ReactorKit.View {
    
    typealias Reactor = GroupDetailViewReactor
    
    private struct Metric {
        // static let topPadding: CGFloat = 16.0
    }
    
    private struct Color {
        // static let backgroundColor = UIColor.color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    
    private struct Font {
        // static let title = UIFont.systemFont(ofSize: 15.0)
    }
    
    /*
     private struct Reusable {
     static let sendCell = ReusableCell<CommonDropDownMenuTableViewCell>()
     }
     */
    
    // MARK: Views
    
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
        // self.view.addSubView(<#UIView#>)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        // <#UIView#>.snp.makeConstraints
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        self.rx.viewDidLoad
            .map { Reactor.Action.firstLoad }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.groupInfo.moodGroup.title }
            .bind(to: self.rx.title)
            .disposed(by: self.disposeBag)
        
        // View
    }
    
    // MARK: - Route
}
