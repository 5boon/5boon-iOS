//
//  SplashViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/08.
//

import UIKit

import ReactorKit
import ReusableKit
import RxCocoa
import RxSwift
import RxViewController
import SnapKit
import Then

final class SplashViewController: BaseViewController, View {
    
    typealias Reactor = SplashViewReactor
    
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
    private let presentMainScreen: () -> Void
    
    // MARK: Views
    private let label = UILabel().then {
        $0.text = "5boon"
    }
    
    // MARK: - Initializing
    init(reactor: Reactor,
         presentLoginScreen: @escaping () -> Void,
         presentMainScreen: @escaping () -> Void) {
        defer { self.reactor = reactor }
        self.presentLoginScreen = presentLoginScreen
        self.presentMainScreen = presentMainScreen
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
        self.view.addSubview(label)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        self.label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        self.rx.viewDidAppear
            .map { _ in Reactor.Action.checkIfAuthenticated }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isAuthenticated }
            .debug()
            .filterNil()
            .distinctUntilChanged()
            // .delay(.seconds(2), scheduler: MainScheduler.instance) // 확인용. 추후 제거
            .subscribe(onNext: { [weak self] isAuthenticated in
                guard let self = self else { return }
                if isAuthenticated {
                    self.presentMainScreen()
                } else {
                    self.presentLoginScreen()
                }
            }).disposed(by: self.disposeBag)
        
        // View
    }
    
    // MARK: - Route
}
