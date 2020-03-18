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

final class LoginViewController: BaseViewController, ReactorKit.View {
    
    typealias Reactor = LoginViewReactor
    
    private struct Metric {
        static let gradientHeight: CGFloat = 375.0 / UIScreen.main.bounds.width * 241.0
        static let leftRightPadding: CGFloat = 36.0
        static let titleTop: CGFloat = 28.0
        
        static let copyrightLeftRight: CGFloat = 16.0
        static let copyrightBottom: CGFloat = 5.0
        
        static let emailTop: CGFloat = 50.0
        static let passwordTop: CGFloat = 12.0
        
        static let fieldHeight: CGFloat = 44.0
        static let buttonHeight: CGFloat = 44.0
        
        static let loginTop: CGFloat = 36.0
        static let snsLoginTop: CGFloat = 14.0
        
        static let findButtonHeight: CGFloat = 20.0
        static let findLineHeight: CGFloat = 10.0
        static let findLineWidth: CGFloat = 1.0
        static let findLineLeftRight: CGFloat = 4.0
    }
    
    private struct Color {
        static let title: UIColor = UIColor.title
        static let copyright: UIColor = UIColor.description
        static let loginTitle: UIColor = UIColor.white
        static let loginButtonBackground: UIColor = UIColor.keyColor
        static let snsLoginTitle: UIColor = UIColor.keyColor
        static let snsLoginButtonBackground: UIColor = UIColor.buttonBG
        static let findButton: UIColor = UIColor.subTitle
        static let signUpButton: UIColor = UIColor.subTitle
    }
    
    private struct Font {
        static let title: UIFont = UIFont.systemFont(ofSize: 20.0)
        static let copyright: UIFont = UIFont.systemFont(ofSize: 10.0)
        static let loginButton: UIFont = UIFont.systemFont(ofSize: 16.0)
        static let findButton: UIFont = UIFont.systemFont(ofSize: 13.0)
        static let signUpButton: UIFont = UIFont.systemFont(ofSize: 13.0)
    }
    
    // MARK: Properties
    private let presentMainScreen: () -> Void
    private let signUpViewControllerFactory: () -> SignUpViewController
    
    // MARK: Views
    private let gradientView = UIView().then {
        $0.backgroundColor = UIColor.keyColor
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Font.title
        $0.textColor = Color.title
        $0.numberOfLines = 2
        $0.text = "새로운 계정을 만들거나\n로그인 하세요."
    }
    
    private let copyrightLabel = UILabel().then {
        $0.font = Font.copyright
        $0.textColor = Color.copyright
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.text = "Copyright 2020. 5boon\nAll pictures cannot be copied without permission."
    }
    
    private let emailTextField = CommonTextField().then {
        $0.reactor = CommonTextFieldReactor(placeholder: "Email", keyboardType: .emailAddress)
    }
    
    private let passwordTextField = CommonTextField().then {
        $0.reactor = CommonTextFieldReactor(isSecureTextEntry: true, placeholder: "Password")
    }

    let loginButton = EMTNeumorphicButton(type: .custom).then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(Color.loginTitle, for: .normal)
        $0.titleLabel?.font = Font.loginButton
        $0.neumorphicLayer?.elementBackgroundColor = Color.loginButtonBackground.cgColor
        $0.neumorphicLayer?.depthType = .convex
        $0.neumorphicLayer?.cornerRadius = 12.0
    }
    
    let socialButton = EMTNeumorphicButton(type: .custom).then {
        $0.setTitle("SNS로 간편 로그인", for: .normal)
        $0.setTitleColor(Color.snsLoginTitle, for: .normal)
        $0.titleLabel?.font = Font.loginButton
        $0.neumorphicLayer?.elementBackgroundColor = Color.snsLoginButtonBackground.cgColor
        $0.neumorphicLayer?.depthType = .convex
        $0.neumorphicLayer?.cornerRadius = 12.0
    }
    
    private let findIDButton = UIButton(type: .system).then {
        $0.setTitle("아이디 찾기", for: .normal)
        $0.setTitleColor(Color.findButton, for: .normal)
        $0.titleLabel?.font = Font.findButton
    }
    
    private let findLine = UIView().then {
        $0.backgroundColor = Color.findButton
    }
    
    private let findPWButton = UIButton(type: .system).then {
        $0.setTitle("비밀번호 찾기", for: .normal)
        $0.setTitleColor(Color.findButton, for: .normal)
        $0.titleLabel?.font = Font.findButton
    }
    
    private let signUpButton = UIButton(type: .system).then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(Color.findButton, for: .normal)
        $0.titleLabel?.font = Font.findButton
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
        
        self.view.addSubview(gradientView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(copyrightLabel)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(socialButton)
        self.view.addSubview(findIDButton)
        self.view.addSubview(findLine)
        self.view.addSubview(findPWButton)
        self.view.addSubview(signUpButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        gradientView.snp.makeConstraints { make in
            make.top.left.right.width.equalToSuperview()
            make.height.equalTo(Metric.gradientHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(gradientView.snp.bottom).offset(Metric.titleTop)
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
        }
        
        copyrightLabel.snp.makeConstraints { make in
            make.bottom.equalTo(-Metric.copyrightBottom - safeAreaInsets.bottom)
            make.left.equalTo(Metric.copyrightLeftRight)
            make.right.equalTo(-Metric.copyrightLeftRight)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.emailTop)
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(Metric.passwordTop)
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(Metric.loginTop)
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
            make.height.equalTo(Metric.buttonHeight)
        }
        
        socialButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(Metric.snsLoginTop)
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
            make.height.equalTo(Metric.buttonHeight)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.right.equalTo(-Metric.leftRightPadding)
            make.height.equalTo(Metric.findButtonHeight)
        }
        
        findIDButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.left.equalTo(Metric.leftRightPadding)
            make.height.equalTo(Metric.findButtonHeight)
        }
        
        findLine.snp.makeConstraints { make in
            make.left.equalTo(findIDButton.snp.right).offset(Metric.findLineLeftRight)
            make.centerY.equalTo(findIDButton.snp.centerY)
            make.height.equalTo(Metric.findLineHeight)
            make.width.equalTo(Metric.findLineWidth)
        }
        
        findPWButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom)
            make.left.equalTo(findLine.snp.right).offset(Metric.findLineLeftRight)
            make.right.lessThanOrEqualTo(signUpButton.snp.left).offset(8.0)
            make.height.equalTo(Metric.findButtonHeight)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        loginButton.rx.tap
            .map { _ -> (String?, String?) in
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
        
        findIDButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushToSFSafariWeb(urlString: "https://www.daum.net")
            }).disposed(by: self.disposeBag)
        
        findPWButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushToSFSafariWeb(urlString: "https://www.google.com")
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
