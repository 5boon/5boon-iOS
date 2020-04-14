//
//  SignUpThirdViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/30.
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

final class SignUpThirdViewController: BaseViewController, ReactorKit.View, Pure.FactoryModule {
    
    // DI
//    struct Dependency {
//        let userService: UserServiceType
//    }
    
    typealias Reactor = SignUpReactor
    
    private struct Metric {
        static let backButtonTop: CGFloat = 52.0
        static let leftRightPadding: CGFloat = 36.0
        
        static let progressWidthHeight: CGFloat = 35.0
        static let progressCenterTop: CGFloat = 130.0
        static let progressCenterLeftRight: CGFloat = 44.0
        static let progressCenterArrowLeftRight: CGFloat = 10.0
        
        static let progressArrowWidthHeight: CGFloat = 24.0
        
        static let titleTop: CGFloat = 30.0
        static let subTitleTop: CGFloat = 45.0
        static let textFieldTop: CGFloat = 12.0
        static let buttonTop: CGFloat = 30.0
        
        static let fieldHeight: CGFloat = 44.0
        static let buttonHeight: CGFloat = 44.0
    }
    
    private struct Color {
        static let progressOn: UIColor = UIColor.progressOn
        static let progressOff: UIColor = UIColor.progressOff
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
        static let button: UIFont = UIFont.systemFont(ofSize: 16.0)
    }
    
    // MARK: Views
    let backButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "back_arrow"), for: .normal)
    }
    
    private let progressFirst = UIImageView().then {
        $0.image = UIImage(named: "ic_check")
        $0.layer.cornerRadius = Metric.progressWidthHeight / 2.0
        $0.layer.masksToBounds = true
        $0.backgroundColor = Color.progressOn
        $0.contentMode = .center
    }
    
    private let arrowFirst = UIImageView().then {
        $0.image = UIImage(named: "ic_double_greyarrow_right")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Color.progressOn
    }
    
    private let progressSecond = UIImageView().then {
        $0.image = UIImage(named: "ic_check")
        $0.layer.cornerRadius = Metric.progressWidthHeight / 2.0
        $0.layer.masksToBounds = true
        $0.backgroundColor = Color.progressOn
        $0.contentMode = .center
    }
    
    private let arrowSecond = UIImageView().then {
        $0.image = UIImage(named: "ic_double_greyarrow_right")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Color.progressOn
    }
    
    private let progressThird = UIImageView().then {
        $0.image = UIImage(named: "ic_loading")
        $0.layer.cornerRadius = Metric.progressWidthHeight / 2.0
        $0.layer.masksToBounds = true
        $0.backgroundColor = Color.progressOn
        $0.contentMode = .center
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Font.title
        $0.textColor = Color.title
        $0.text = "계정 생성"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = Font.subTitle
        $0.textColor = Color.subTitle
        $0.text = "이름을 입력해주세요"
    }
    
    private let nameTextField = CommonTextField().then {
        $0.reactor = CommonTextFieldReactor(placeholder: "Name")
    }
    
    let doneButton = EMTNeumorphicButton(type: .custom).then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(Color.doneButton, for: .normal)
        $0.setTitleColor(Color.disableButton, for: .disabled)
        $0.titleLabel?.font = Font.button
        $0.neumorphicLayer?.elementBackgroundColor = Color.doneButtonBackground.cgColor
        $0.neumorphicLayer?.depthType = .convex
        $0.neumorphicLayer?.cornerRadius = 12.0
        $0.neumorphicLayer?.lightShadowOpacity = 0.1
        $0.neumorphicLayer?.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    private let loadingIndicator = UIActivityIndicatorView().then {
        $0.style = .large
        $0.color = Color.loadingIndicator
        $0.hidesWhenStopped = true
    }
    
    // MARK: Properties
    let pushFinishedStepScreen: () -> SignUpFinishedViewController
//    let signupThirdControllerFactory: SignUpThirdViewController.Factory
    
    // MARK: - Initializing
    init(reactor: Reactor,
//         signupThirdControllerFactory: SignUpThirdViewController.Factory,
         pushFinishedStepScreen: @escaping () -> SignUpFinishedViewController) {
        defer { self.reactor = reactor }
//        self.signupThirdControllerFactory = signupThirdControllerFactory
        self.pushFinishedStepScreen = pushFinishedStepScreen
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
        self.view.addSubview(progressFirst)
        self.view.addSubview(arrowFirst)
        self.view.addSubview(progressSecond)
        self.view.addSubview(arrowSecond)
        self.view.addSubview(progressThird)
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        self.view.addSubview(nameTextField)
        self.view.addSubview(doneButton)
        
        self.view.addSubview(loadingIndicator)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(Metric.backButtonTop)
            make.left.equalTo(Metric.leftRightPadding)
        }
        
        progressSecond.snp.makeConstraints { make in
            make.top.equalTo(Metric.progressCenterTop)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Metric.progressWidthHeight)
        }
        
        arrowFirst.snp.makeConstraints { make in
            make.right.equalTo(progressSecond.snp.left).offset(-Metric.progressCenterArrowLeftRight)
            make.width.height.equalTo(Metric.progressArrowWidthHeight)
            make.centerY.equalTo(progressSecond.snp.centerY)
        }
        
        arrowSecond.snp.makeConstraints { make in
            make.left.equalTo(progressSecond.snp.right).offset(Metric.progressCenterArrowLeftRight)
            make.width.height.equalTo(Metric.progressArrowWidthHeight)
            make.centerY.equalTo(progressSecond.snp.centerY)
        }
        
        progressFirst.snp.makeConstraints { make in
            make.width.height.equalTo(Metric.progressWidthHeight)
            make.right.equalTo(progressSecond.snp.left).offset(-Metric.progressCenterLeftRight)
            make.centerY.equalTo(progressSecond.snp.centerY)
        }
        
        progressThird.snp.makeConstraints { make in
            make.width.height.equalTo(Metric.progressWidthHeight)
            make.centerY.equalTo(progressSecond.snp.centerY)
            make.left.equalTo(progressSecond.snp.right).offset(Metric.progressCenterLeftRight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
            make.top.equalTo(progressSecond.snp.bottom).offset(Metric.titleTop)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.subTitleTop)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.left.equalTo(Metric.leftRightPadding)
            make.right.equalTo(-Metric.leftRightPadding)
            make.height.equalTo(Metric.fieldHeight)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(Metric.textFieldTop)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(Metric.buttonTop)
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
        
        doneButton.rx.tap
            .map { Reactor.Action.signUp }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isValidateThirdStepField }
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isLoading }
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.signupFinished }
            .observeOn(MainScheduler.asyncInstance)
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.presentFinish()
            }).disposed(by: self.disposeBag)
        
        // View
        nameTextField.rx.text
            .map { Reactor.Action.setName($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Route
    private func presentFinish() {
        let controller = self.pushFinishedStepScreen()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
    }
}
