//
//  LoginViewController.swift
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

final class LoginViewController: BaseViewController, View {
    
    typealias Reactor = LoginViewReactor
    
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
    private let presentMainScreen: () -> Void
    
    // MARK: Views
    private let label = UILabel().then {
        $0.text = "Login"
    }
    
    // MARK: - Initializing
    init(reactor: Reactor,
         presentMainScreen: @escaping () -> Void) {
        defer { self.reactor = reactor }
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
        
        // State
        
        // View
    }
        
    // MARK: - Route
}
