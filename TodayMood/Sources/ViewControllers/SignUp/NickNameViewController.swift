//
//  NickNameViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/19.
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

final class NickNameViewController: BaseViewController, ReactorKit.View, Pure.FactoryModule {
    
    typealias Reactor = NickNameViewReactor
    
    private struct Metric {
        static let backButtonTop: CGFloat = 52.0
        
        static let titleTop: CGFloat = 135.0
        static let leftRightPadding: CGFloat = 36.0
        
        static let subTitleTop: CGFloat = 45.0
        
        static let nickNameTop: CGFloat = 12.0
        
        static let fieldHeight: CGFloat = 44.0
        static let buttonHeight: CGFloat = 44.0
        
        static let doneButtonTop: CGFloat = 24.0
    }
    
    private struct Color {
        static let title: UIColor = UIColor.keyColor
        static let subTitle: UIColor = UIColor.title
        static let doneButton: UIColor = UIColor.keyColor
        static let disableButton: UIColor = UIColor.keyColor.alpha(0.6)
        static let doneButtonBackground: UIColor = UIColor.buttonBG
        static let loadingIndicator: UIColor = UIColor.keyColor
    }
    
    private struct Font {
        static let title: UIFont = UIFont.boldSystemFont(ofSize: 20.0)
        static let subTitle: UIFont = UIFont.systemFont(ofSize: 16.0)
        static let doneButton: UIFont = UIFont.systemFont(ofSize: 16.0)
    }
    
    // MARK: Properties
    private let presentMainScreen: () -> Void
    
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
        $0.text = "닉네임을 입력해 주세요."
    }
    
    private let nickNameTextField = CommonTextField().then {
        $0.reactor = CommonTextFieldReactor(placeholder: "NickName")
    }
    
    let doneButton = EMTNeumorphicButton(type: .custom).then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(Color.doneButton, for: .normal)
        $0.setTitleColor(Color.disableButton, for: .disabled)
        $0.titleLabel?.font = Font.doneButton
        $0.neumorphicLayer?.elementBackgroundColor = Color.doneButtonBackground.cgColor
        $0.neumorphicLayer?.depthType = .convex
        $0.neumorphicLayer?.cornerRadius = 12.0
    }
    
    private let loadingIndicator = UIActivityIndicatorView().then {
        $0.style = .large
        $0.color = Color.loadingIndicator
        $0.hidesWhenStopped = true
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
        
        self.view.addSubview(backButton)
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        self.view.addSubview(nickNameTextField)
        self.view.addSubview(doneButton)
        self.view.addSubview(loadingIndicator)
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
        
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(Metric.nickNameTop)
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
            make.height.equalTo(Metric.fieldHeight)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(Metric.doneButtonTop)
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
            make.height.equalTo(Metric.buttonHeight)
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
        
        nickNameTextField.rx.text
            .map { Reactor.Action.setNickName($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        nickNameTextField.rx.clearText
            .map { Reactor.Action.setNickName(nil) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        doneButton.rx.tap
            .map { Reactor.Action.signup }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isValidate }
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isSignUpFinished }
            .observeOn(MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.presentMainScreen()
            }).disposed(by: self.disposeBag)
    }
    
    // MARK: - Route
}
