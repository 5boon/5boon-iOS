//
//  FindPasswordViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/28.
//

import UIKit

import EMTNeumorphicView
//import Pure
import ReactorKit
import ReusableKit
import RxCocoa
import RxSwift
import RxViewController
import SnapKit
import Then

final class FindPasswordViewController: BaseViewController, ReactorKit.View {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    typealias Reactor = FindPasswordViewReactor
    
    // MARK: Properties
    private struct Metric {
        static let backButtonTop: CGFloat = 48.0
        static let backButtonWidthHeight: CGFloat = 24.0
        static let backButtonLeft: CGFloat = 27.0
        
        static let leftRightPadding: CGFloat = 36.0
        
        static let fieldHeight: CGFloat = 44.0
        static let buttonHeight: CGFloat = 44.0
        
        static let titleTop: CGFloat = 135.0
        
        static let subTitleTop: CGFloat = 35.0
        
        static let idTop: CGFloat = 20.0
        static let nameTop: CGFloat = 12.0
        static let doneButtonTop: CGFloat = 24.0
        
        static let resultButtonTop: CGFloat = 35.0
        static let resultButtonBottom: CGFloat = 30.0
        
        static let notFoundTop: CGFloat = 5.0
    }
    
    private struct Color {
        static let title: UIColor = UIColor.keyColor
        static let subTitle: UIColor = UIColor.title
        static let doneButton: UIColor = UIColor.keyColor
        static let disableButton: UIColor = UIColor.keyColor.alpha(0.6)
        static let doneButtonBackground: UIColor = UIColor.buttonBG
        static let resultBackground: UIColor = UIColor.baseBG
        static let loadingIndicator: UIColor = UIColor.keyColor
        static let notFoundLabel: UIColor = UIColor.invalidColor
    }
    
    private struct Font {
        static let title: UIFont = UIFont.boldSystemFont(ofSize: 20.0)
        static let subTitle: UIFont = UIFont.systemFont(ofSize: 16.0)
        static let doneButton: UIFont = UIFont.systemFont(ofSize: 16.0)
        
        static let notFoundLabel: UIFont = UIFont.systemFont(ofSize: 12.0)
        
        static let result: UIFont = UIFont.systemFont(ofSize: 16.0)
        static let resultBold: UIFont = UIFont.boldSystemFont(ofSize: 16.0)
    }
    
    // MARK: Views
    private let backButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "back_arrow"), for: .normal)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Font.title
        $0.textColor = Color.title
        $0.text = "비밀번호 찾기"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = Font.subTitle
        $0.textColor = Color.subTitle
        $0.numberOfLines = 2
        $0.text = "회원가입 당시 입력한\n아이디와 이름을 입력해주세요"
    }
    
    private let idTextField = CommonTextField().then {
        $0.reactor = CommonTextFieldReactor(placeholder: "ID")
    }
    
    private let nameTextField = CommonTextField().then {
        $0.reactor = CommonTextFieldReactor(placeholder: "Name")
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
    
    let resultBackView = UIView().then {
        $0.backgroundColor = Color.resultBackground
    }
    private let resultLabel = UILabel().then {
        $0.font = Font.subTitle
        $0.textColor = Color.subTitle
        $0.numberOfLines = 3
        $0.text = "회원가입 시 입력한 이메일\ndorosi@kakao.com 으로\n임시 비밀번호가 발송되었습니다."
    }
    let resultDoneButton = EMTNeumorphicButton(type: .custom).then {
        $0.setTitle("로그인 하기", for: .normal)
        $0.setTitleColor(Color.doneButton, for: .normal)
        $0.setTitleColor(Color.disableButton, for: .disabled)
        $0.titleLabel?.font = Font.doneButton
        $0.neumorphicLayer?.elementBackgroundColor = Color.doneButtonBackground.cgColor
        $0.neumorphicLayer?.depthType = .convex
        $0.neumorphicLayer?.cornerRadius = 12.0
        $0.neumorphicLayer?.lightShadowOpacity = 0.1
        $0.neumorphicLayer?.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    private let loadingIndicator = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
        $0.style = .large
        $0.color = Color.loadingIndicator
    }
    
    let notFoundLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = Font.notFoundLabel
        $0.textColor = Color.notFoundLabel
        $0.textAlignment = .right
        $0.isHidden = true
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
        self.view.addSubview(idTextField)
        self.view.addSubview(nameTextField)
        self.view.addSubview(notFoundLabel)
        self.view.addSubview(doneButton)
        
        self.view.addSubview(resultBackView)
        resultBackView.addSubview(resultLabel)
        resultBackView.addSubview(resultDoneButton)
        
        self.view.addSubview(loadingIndicator)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(Metric.backButtonTop)
            make.left.equalTo(Metric.backButtonLeft)
            make.width.height.equalTo(Metric.backButtonWidthHeight)
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
        
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(Metric.idTop)
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(Metric.nameTop)
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        notFoundLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(Metric.notFoundTop)
            make.right.equalTo(-Metric.leftRightPadding)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(Metric.doneButtonTop)
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
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
            .map { (self.idTextField.text, self.nameTextField.text) }
            .map { Reactor.Action.find($0.0, $0.1) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        resultDoneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popToRootViewController(animated: true)
            }).disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.findResult }
            .map { $0 == nil }
            .bind(to: resultBackView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.findResult }
            .filterNil()
            .subscribe(onNext: { [weak self] user in
                guard let self = self else { return }
                self.setFindResult(user)
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.failedText }
            .filterNil()
            .bind(to: notFoundLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.failedText }
            .map { $0 == nil }
            .bind(to: notFoundLabel.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        // View
    }
    
    private func setFindResult(_ user: User) {
        // $0.text = "회원님의 아이디는 dorosi 입니다.\n(가입일: 2020. 05. 05)"
        guard let email = user.email else { return }
        
        let fullText = "회원가입 시 입력한 이메일\n\(email) 으로\n임시 비밀번호가 발송되었습니다."
        let range = (fullText as NSString).range(of: email)
        let attrString = NSMutableAttributedString(string: fullText, attributes: [
                NSAttributedString.Key.font: Font.result,
                NSAttributedString.Key.foregroundColor: Color.subTitle
        ])
        
        attrString.addAttributes([NSAttributedString.Key.font: Font.resultBold],
                                   range: range)
        
        resultLabel.attributedText = attrString
    }
    
    // MARK: - Route
}
