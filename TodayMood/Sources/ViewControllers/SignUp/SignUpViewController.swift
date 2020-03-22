//
//  SignUpViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/14.
//

import UIKit

import EMTNeumorphicView
import Pure
import ReactorKit
import ReusableKit
import RxCocoa
import RxSwift
import RxViewController
import SnapKit
import Then

final class SignUpViewController: BaseViewController, ReactorKit.View, Pure.FactoryModule {
    
    typealias Reactor = SignUpViewReactor
    
    struct Dependency {
        
    }
    
    private struct Metric {
        static let backButtonTop: CGFloat = 52.0
        
        static let titleTop: CGFloat = 135.0
        static let leftRightPadding: CGFloat = 36.0
        
        static let subTitleTop: CGFloat = 45.0
        
        static let emailTop: CGFloat = 12.0
        static let passwordTop: CGFloat = 12.0
        
        static let fieldHeight: CGFloat = 44.0
        static let buttonHeight: CGFloat = 44.0
        
        static let nextButtonTop: CGFloat = 24.0
    }
    
    private struct Color {
        static let title: UIColor = UIColor.keyColor
        static let subTitle: UIColor = UIColor.title
        static let nextButton: UIColor = UIColor.keyColor
        static let disableButton: UIColor = UIColor.keyColor.alpha(0.6)
        static let nextButtonBackground: UIColor = UIColor.buttonBG
    }
    
    private struct Font {
        static let title: UIFont = UIFont.boldSystemFont(ofSize: 20.0)
        static let subTitle: UIFont = UIFont.systemFont(ofSize: 16.0)
        static let nextButton: UIFont = UIFont.systemFont(ofSize: 16.0)
    }
    
    // MARK: Properties
    private let nickNameViewControllerFactory: (String, String) -> NickNameViewController
    
    // MARK: Views
    private let backButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "back_arrow")?.withRenderingMode(.alwaysTemplate),
                    for: .normal)
        $0.tintColor = UIColor.keyColor
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Font.title
        $0.textColor = Color.title
        $0.text = "계정 생성"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = Font.subTitle
        $0.textColor = Color.subTitle
        $0.text = "ID와 Password를 입력해주세요."
    }
    
    private let emailTextField = CommonTextField().then {
        $0.reactor = CommonTextFieldReactor(placeholder: "Email", keyboardType: .emailAddress)
    }
    
    private let passwordTextField = CommonTextField().then {
        $0.reactor = CommonTextFieldReactor(isSecureTextEntry: true, placeholder: "Password")
    }
    
    let nextButton = EMTNeumorphicButton(type: .custom).then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(Color.nextButton, for: .normal)
        $0.setTitleColor(Color.disableButton, for: .disabled)
        $0.titleLabel?.font = Font.nextButton
        $0.neumorphicLayer?.elementBackgroundColor = Color.nextButtonBackground.cgColor
        $0.neumorphicLayer?.depthType = .convex
        $0.neumorphicLayer?.cornerRadius = 12.0
    }
    
    // MARK: - Initializing
    init(reactor: Reactor,
         nickNameViewControllerFactory: @escaping (String, String) -> NickNameViewController) {
        defer { self.reactor = reactor }
        self.nickNameViewControllerFactory = nickNameViewControllerFactory
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
        
        self.view.addSubview(backButton)
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(nextButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(Metric.backButtonTop)
            make.left.equalTo(Metric.leftRightPadding)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(Metric.titleTop)
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.subTitleTop)
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(Metric.emailTop)
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
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(Metric.nextButtonTop)
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
            make.height.equalTo(Metric.buttonHeight)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushToNickName()
            }).disposed(by: self.disposeBag)
        
        emailTextField.rx.text
            .map { Reactor.Action.setEmail($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        emailTextField.rx.clearText
            .map { Reactor.Action.setEmail(nil) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        passwordTextField.rx.text
            .map { Reactor.Action.setPassword($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        passwordTextField.rx.clearText
            .map { Reactor.Action.setPassword(nil) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isValidate }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        // View
    }
    
    // MARK: - Route
    private func pushToNickName() {
//        let reactor = NickNameViewReactor()
//        let viewController = NickNameViewController(reactor: reactor)
        guard let reactor = self.reactor else { return }
        guard let email = reactor.currentState.email, let password = reactor.currentState.password else { return }
        let viewController = self.nickNameViewControllerFactory(email, password)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
