//
//  LoginViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/08.
//

import UIKit

import EMTNeumorphicView
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
    private let signUpViewControllerFactory: () -> SignUpViewController
    
    // MARK: Views
    private let emailTextField = UITextField().then {
        $0.placeholder = "Email"
        $0.clearButtonMode = .whileEditing
    }
    
    private let passwordTextField = UITextField().then {
        $0.placeholder = "Password"
        $0.isSecureTextEntry = true
        $0.clearButtonMode = .whileEditing
    }
    
    let loginButton = UIButton(type: .system).then {
        $0.setTitle("로그인", for: .normal)
    }
    
    private let socialButton = UIButton(type: .system).then {
        $0.setTitle("SNS 로그인", for: .normal)
        
    }
    
    private let signUpButton = UIButton(type: .system).then {
        $0.setTitle("회원가입", for: .normal)
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10.0
        $0.distribution = .fillEqually
    }
    
    // MARK: - Initializing
    init(reactor: Reactor,
         presentMainScreen: @escaping () -> Void,
         signUpViewControllerFactory: @escaping () -> SignUpViewController) {
        defer { self.reactor = reactor }
        self.presentMainScreen = presentMainScreen
        self.signUpViewControllerFactory = signUpViewControllerFactory
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
        
        self.view.addSubview(stackView)
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(socialButton)
        stackView.addArrangedSubview(signUpButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(250.0)
            make.height.equalTo(400)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        loginButton.rx.tap
            .map { [weak self] _ -> (String?, String?) in
                guard let self = self else { return (nil, nil) }
                return (self.emailTextField.text, self.passwordTextField.text)
        }
        .map { Reactor.Action.login(userName: $0, password: $1) }
        .bind(to: reactor.action)
        .disposed(by: self.disposeBag)
        
        signUpButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushToSignUp()
            }).disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isLoggedIn }
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                self?.presentMainScreen()
            }).disposed(by: self.disposeBag)
        
        // View
    }
    
    // MARK: - Route
    private func pushToSignUp() {
        let viewController = self.signUpViewControllerFactory()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func presentSocialLogin() {
        
    }
    
}
