//
//  SettingsViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/22.
//

import UIKit

import ReactorKit
import ReusableKit
import RxCocoa
import RxSwift
import RxViewController
import SnapKit
import Then

final class SettingsViewController: BaseViewController, View {
    
    typealias Reactor = SettingsViewReactor
    
    private struct Metric {
        // static let topPadding: CGFloat = 16.0
    }
    
    private struct Color {
        // static let backgroundColor = UIColor.color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    }
    
    private struct Font {
        // static let title = UIFont.systemFont(ofSize: 15.0)
    }
    
    // MARK: Properties
    private let presentLoginScreen: () -> Void
    
    // MARK: Views
    let logoutButton = UIButton(type: .system).then {
        $0.setTitle("Logout", for: .normal)
    }
    
    // MARK: - Initializing
    init(reactor: Reactor,
         presentLoginScreen: @escaping () -> Void) {
        defer { self.reactor = reactor }
        self.presentLoginScreen = presentLoginScreen
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        
        self.view.addSubview(logoutButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        logoutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        logoutButton.rx.tap
            .map { Reactor.Action.logout }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isLoggedOut }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.presentLoginScreen()
            }).disposed(by: self.disposeBag)
        
        // View
    }
    
    
    // MARK: - Route
}
