//
//  GroupAddViewController.swift
//  TodayMood
//
//  Created Fernando on 2020/05/18.
//  Copyright © 2020 5boon. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import ReusableKit

final class GroupAddViewController: BaseViewController, ReactorKit.View {
    
    // MARK: Properties
    typealias Reactor = GroupAddViewReactor
    
    private struct Metric {
        /// Common
        static let titleSize : CGFloat = 20.0
        static let titleTop: CGFloat = 180.0
        static let fieldDescriptionTitleSize: CGFloat = 12.0
        static let textFieldTextSize: CGFloat = 16.0
        static let closeWithHeight: CGFloat = 34.0
        
        static let topMargin: CGFloat = 44.0
        static let leftMargin: CGFloat = 37.0
        static let rightMargin: CGFloat = -32.0
        
        /// TextField
        static let textFieldTopMargin: CGFloat = 5.0
        static let textFieldBottomMargin: CGFloat = 18.0
        static let textFieldHeight: CGFloat = 51.0
        
    }
    
    private struct Color {
        /// Common
        static let background = UIColor.black
        static let text = UIColor.white
        
        static let disabled = UIColor.gray
        static let enabled = UIColor.keyColor
        
        /// TextField
        static let textFieldNormal = UIColor.white
        static let textFieldDisabled = UIColor.white.alpha(0.5)
        
        static let loadingIndicator = UIColor.keyColor
    }
    
    private struct Font {
        static let title = UIFont.boldSystemFont(ofSize: Metric.titleSize)
        static let fieldTitle = UIFont.systemFont(ofSize: Metric.fieldDescriptionTitleSize)
    }
    
    private struct Localized {
        static let title = NSLocalizedString("새로운 그룹\n만들기", comment: "새로운 그룹 만들기")
        static let close = NSLocalizedString("닫기", comment: "닫기")
        static let next = NSLocalizedString("다음", comment: "다음")
        
        static let groupNameTitle = NSLocalizedString("그룹 이름", comment: "그룹 이름")
        static let groupDescriptionTitle = NSLocalizedString("그룹 소개", comment: "그룹 소개")
    }
    
    private let closeButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "ic_close"), for: .normal)
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 34.0 / 2
        $0.layer.masksToBounds = true
    }
    
    let nextButton = UIButton().then {
        $0.setTitle(Localized.next, for: .normal)
        $0.setTitleColor(Color.disabled, for: .disabled)
        $0.setTitleColor(Color.enabled, for: .normal)
    }
    
    let titleLabel = UILabel().then {
        $0.text = Localized.title
        $0.font = Font.title
        $0.textColor = Color.text
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.sizeToFit()
    }
    
    let groupNameLabel = UILabel().then {
        $0.text = Localized.groupNameTitle
        $0.textColor = Color.text
        $0.font = Font.fieldTitle
    }
    
    let groupNameField = UITextField().then {
        $0.textColor = Color.text
        $0.borderStyle = .line
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = Color.text.cgColor
        $0.addPadding(padding: .equalSpacing(10.0))
    }
    
    let groupDescriptionLabel = UILabel().then {
        $0.text = Localized.groupDescriptionTitle
        $0.textColor = Color.text
        $0.font = Font.fieldTitle
    }
    
    let groupDescriptionField = UITextField().then {
        $0.textColor = Color.text
        $0.borderStyle = .line
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = Color.text.cgColor
        $0.addPadding(padding: .equalSpacing(10.0))
    }
    
    private let loadingIndicator = UIActivityIndicatorView().then {
        $0.hidesWhenStopped = true
        $0.style = .large
        $0.color = Color.loadingIndicator
    }
    
    // MARK: Initializing
    init(reactor: GroupAddViewReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.background
    }
    
    override func addViews() {
        super.addViews()
        self.view.addSubview(closeButton)
        self.view.addSubview(nextButton)
        self.view.addSubview(titleLabel)
        
        self.view.addSubview(groupNameLabel)
        self.view.addSubview(groupNameField)
        self.view.addSubview(groupDescriptionLabel)
        self.view.addSubview(groupDescriptionField)
        
        self.view.addSubview(loadingIndicator)
    }
    
    override func setupConstraints() {
        
        self.closeButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Metric.leftMargin)
            make.top.equalToSuperview().offset(Metric.topMargin)
            make.width.height.equalTo(Metric.closeWithHeight)
        }
        
        self.nextButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(Metric.rightMargin)
            make.top.equalToSuperview().offset(Metric.topMargin)
        }
        
        self.titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Metric.titleTop)
            make.left.equalToSuperview().offset(Metric.leftMargin)
        }
        
        self.groupNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Metric.leftMargin)
            make.top.equalTo(titleLabel.snp.bottom).offset(Metric.textFieldBottomMargin)
        }
        
        self.groupNameField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Metric.leftMargin)
            make.right.equalToSuperview().offset(Metric.rightMargin)
            make.top.equalTo(groupNameLabel.snp.bottom).offset(Metric.textFieldTopMargin)
            make.height.equalTo(Metric.textFieldHeight)
        }
        
        self.groupDescriptionLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Metric.leftMargin)
            make.top.equalTo(groupNameField.snp.bottom).offset(Metric.textFieldBottomMargin)
        }
        
        self.groupDescriptionField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(Metric.leftMargin)
            make.right.equalToSuperview().offset(Metric.rightMargin)
            make.top.equalTo(groupDescriptionLabel.snp.bottom).offset(Metric.textFieldTopMargin)
            make.height.equalTo(Metric.textFieldHeight)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: Binding
    func bind(reactor: GroupAddViewReactor) {
        
        // Action
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: false, completion: nil)
            }).disposed(by: self.disposeBag)
        
        nextButton.rx.tap
            .map { Reactor.Action.createGroup }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isValid }
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.groupNameValid }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] groupNameValid  in
                guard let self = self else { return }
                self.groupNameField.layer.borderColor = groupNameValid ? Color.textFieldNormal.cgColor : Color.textFieldDisabled.cgColor
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.summaryValid }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] summaryValid  in
                guard let self = self else { return }
                self.groupDescriptionField.layer.borderColor = summaryValid ? Color.textFieldNormal.cgColor : Color.textFieldDisabled.cgColor
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.createGroupFinished }
            .observeOn(MainScheduler.instance)
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                reactor.action.onNext(.clearFinish)
                self.createGroupFinishedAlert()
            }).disposed(by: self.disposeBag)
        
        // View
        groupNameField.rx.text
            .map { Reactor.Action.setGroupName($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        groupDescriptionField.rx.text
            .map { Reactor.Action.setSummary($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - Route
    private func createGroupFinishedAlert() {
        let alert = UIAlertController(title: "그룹 생성", message: "그룹이 생성되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
