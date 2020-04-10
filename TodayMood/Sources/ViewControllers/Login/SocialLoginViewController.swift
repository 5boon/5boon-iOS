//
//  SocialLoginViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/14.
//

import UIKit

import Pure
import ReactorKit
import ReusableKit
import RxCocoa
import RxSwift
import RxViewController
import SnapKit
import Then

typealias SocialLoginInfo = (type: SocialLoginTypes, token: String, email: String?)

final class SocialLoginViewController: BaseViewController, View {
    
    typealias Reactor = SocialLoginViewReactor
    
    private struct Metric {
        static let closeWidthHeight: CGFloat = 34.0
        static let closeBottom: CGFloat = 75.0
        
        static let leftPadding: CGFloat = 38.0
        static let rightPadding: CGFloat = 16.0
        static let buttonHeight: CGFloat = 52.0
        static let stackTop: CGFloat = 78.0
        static let stackWidth: CGFloat = 200.0
        static let stackHeight: CGFloat = Metric.buttonHeight * 5
    }
    
    private struct Color {
        static let background: UIColor = UIColor.black.alpha(0.9)
        static let closeButtonBorder: UIColor = UIColor.white
        static let title: UIColor = UIColor.white
    }
    
    private struct Font {
        static let title: UIFont = UIFont.systemFont(ofSize: 20.0)
    }
    
    // MARK: Properties
    private let socialLoginInfoSubject = PublishSubject<SocialLoginInfo>()
    var socialLoginInfoObservable: Observable<SocialLoginInfo> {
        return socialLoginInfoSubject.asObservable()
    }
    
    // MARK: Views
    private let containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Font.title
        $0.textColor = Color.title
        $0.numberOfLines = 2
        $0.text = "SNS 계정으로\n간편하게 로그인하세요."
    }
    
    private let stackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    private let kakaoButton = SocialLoginButton().then {
        $0.reactor = SocialLoginButtonReactor(type: .kakao)
    }
    
    private let googleButton = SocialLoginButton().then {
        $0.reactor = SocialLoginButtonReactor(type: .google)
    }
    
    private let naverButton = SocialLoginButton().then {
        $0.reactor = SocialLoginButtonReactor(type: .naver)
    }
    
    private let facebookButton = SocialLoginButton().then {
        $0.reactor = SocialLoginButtonReactor(type: .facebook)
    }
    
    private let appleButton = SocialLoginButton().then {
        $0.reactor = SocialLoginButtonReactor(type: .apple,
                                              isShowUnderLine: false)
    }
    
    private let closeButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "ic_close"), for: .normal)
        $0.layer.borderColor = Color.closeButtonBorder.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = Metric.closeWidthHeight / 2.0
        $0.layer.masksToBounds = true
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
        self.view.backgroundColor = Color.background
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        
        self.view.addSubview(closeButton)
        self.view.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(stackView)
        
        stackView.addArrangedSubview(kakaoButton)
        stackView.addArrangedSubview(googleButton)
        stackView.addArrangedSubview(naverButton)
        stackView.addArrangedSubview(facebookButton)
        stackView.addArrangedSubview(appleButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-Metric.closeBottom)
            make.width.height.equalTo(Metric.closeWidthHeight)
        }
        
        containerView.snp.makeConstraints { make in
            make.left.equalTo(Metric.leftPadding)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.stackTop)
            make.width.equalTo(Metric.stackWidth)
            make.height.equalTo(Metric.stackHeight)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        
        let kakaoTap = kakaoButton.rx.tap
            .map { SocialLoginTypes.kakao }
        
        let googleTap = googleButton.rx.tap
            .map { SocialLoginTypes.google }
        
        let naverTap = naverButton.rx.tap
            .map { SocialLoginTypes.naver }
        
        let facebookTap = facebookButton.rx.tap
            .map { SocialLoginTypes.facebook }
        
        let appleTap = appleButton.rx.tap
            .map { SocialLoginTypes.apple }
        
        let loginButtonObservable = Observable.merge(kakaoTap, googleTap, naverTap, facebookTap, appleTap)
        loginButtonObservable
            .debug()
            .map { Reactor.Action.login($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        
        // View
    }
    
    // MARK: - Route
}
