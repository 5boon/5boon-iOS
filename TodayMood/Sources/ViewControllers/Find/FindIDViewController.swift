//
//  FindIDViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/28.
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

final class FindIDViewController: BaseViewController, View {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    typealias Reactor = FindIDViewReactor
    
    // MARK: Properties
    private struct Metric {
        static let backButtonTop: CGFloat = 52.0
        static let leftRightPadding: CGFloat = 36.0
        
        static let fieldHeight: CGFloat = 44.0
        static let buttonHeight: CGFloat = 44.0
        
        static let titleTop: CGFloat = 135.0
        
        static let subTitleTop: CGFloat = 35.0
        
        static let nameTop: CGFloat = 20.0
        static let emailTop: CGFloat = 12.0
        static let doneButtonTop: CGFloat = 24.0
        
        static let resultButtonTop: CGFloat = 35.0
        static let resultButtonBottom: CGFloat = 30.0
    }
    
    private struct Color {
        static let title: UIColor = UIColor.keyColor
        static let subTitle: UIColor = UIColor.title
        static let doneButton: UIColor = UIColor.keyColor
        static let disableButton: UIColor = UIColor.keyColor.alpha(0.6)
        static let doneButtonBackground: UIColor = UIColor.buttonBG
        static let findPasswordButton: UIColor = UIColor.subTitle
        static let resultBackground: UIColor = UIColor.baseBG
    }
    
    private struct Font {
        static let title: UIFont = UIFont.boldSystemFont(ofSize: 20.0)
        static let subTitle: UIFont = UIFont.systemFont(ofSize: 16.0)
        static let doneButton: UIFont = UIFont.systemFont(ofSize: 16.0)
        static let findPasswordButton: UIFont = UIFont.systemFont(ofSize: 13.0)
    }
    
    // MARK: Views
    private let backButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "back_arrow")?.withRenderingMode(.alwaysTemplate),
                    for: .normal)
        $0.tintColor = UIColor.keyColor
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Font.title
        $0.textColor = Color.title
        $0.text = "아이디 찾기"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = Font.subTitle
        $0.textColor = Color.subTitle
        $0.numberOfLines = 2
        $0.text = "회원가입 당시 입력한\n이름과 이메일을 입력해주세요"
    }
    
    private let nameTextField = CommonTextField().then {
        $0.reactor = CommonTextFieldReactor(placeholder: "Name")
    }
    
    private let emailTextField = CommonTextField().then {
        $0.reactor = CommonTextFieldReactor(placeholder: "Email", keyboardType: .emailAddress)
    }
    
    let doneButton = EMTNeumorphicButton(type: .custom).then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(Color.doneButton, for: .normal)
        $0.setTitleColor(Color.disableButton, for: .disabled)
        $0.titleLabel?.font = Font.doneButton
        $0.neumorphicLayer?.elementBackgroundColor = Color.doneButtonBackground.cgColor
        $0.neumorphicLayer?.depthType = .convex
        $0.neumorphicLayer?.cornerRadius = 12.0
        $0.neumorphicLayer?.lightShadowOpacity = 0.1
        $0.neumorphicLayer?.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    private let resultBackView = UIView().then {
        $0.backgroundColor = Color.resultBackground
    }
    private let resultLabel = UILabel().then {
        $0.font = Font.subTitle
        $0.textColor = Color.subTitle
        $0.numberOfLines = 2
        $0.text = "회원님의 아이디는 dorosi 입니다.\n(가입일: 2020. 05. 05)"
    }
    let resultDoneButton = EMTNeumorphicButton(type: .custom).then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(Color.doneButton, for: .normal)
        $0.setTitleColor(Color.disableButton, for: .disabled)
        $0.titleLabel?.font = Font.doneButton
        $0.neumorphicLayer?.elementBackgroundColor = Color.doneButtonBackground.cgColor
        $0.neumorphicLayer?.depthType = .convex
        $0.neumorphicLayer?.cornerRadius = 12.0
        $0.neumorphicLayer?.lightShadowOpacity = 0.1
        $0.neumorphicLayer?.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    let findPasswordButton = UIButton(type: .system).then {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: Font.findPasswordButton,
            .foregroundColor: Color.findPasswordButton,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        $0.setAttributedTitle(NSAttributedString(string: "비밀번호 찾기", attributes: attributes), for: .normal)
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
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        
        self.view.addSubview(backButton)
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(emailTextField)
        self.view.addSubview(doneButton)
        
        self.view.addSubview(resultBackView)
        resultBackView.addSubview(resultLabel)
        resultBackView.addSubview(resultDoneButton)
        resultBackView.addSubview(findPasswordButton)
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
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(Metric.nameTop)
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(Metric.emailTop)
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(Metric.doneButtonTop)
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
            make.height.equalTo(Metric.buttonHeight)
        }
        
        resultBackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.subTitleTop)
            make.left.right.bottom.equalToSuperview()
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
        }
        
        resultDoneButton.snp.makeConstraints { make in
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
            make.height.equalTo(Metric.buttonHeight)
            make.top.equalTo(resultLabel.snp.bottom).offset(Metric.resultButtonTop)
        }
        
        findPasswordButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(resultDoneButton.snp.bottom).offset(Metric.resultButtonBottom)
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
        
        doneButton.rx.tap
            .map { Reactor.Action.find("", "") }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        resultDoneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popToRootViewController(animated: true)
            }).disposed(by: self.disposeBag)
        
        findPasswordButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.pushToFindPassword()
            }).disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.findResult }
            .map { $0 == nil }
            .bind(to: resultBackView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        // View
    }
    
    // MARK: - Route
    private func pushToFindPassword() {
        let reactor = FindPasswordViewReactor()
        let viewController = FindPasswordViewController(reactor: reactor)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
