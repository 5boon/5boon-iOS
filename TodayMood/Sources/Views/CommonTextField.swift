//
//  CommonTextField.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/17.
//

import UIKit

import EMTNeumorphicView
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class CommonTextField: BaseView, View {
    
    typealias Reactor = CommonTextFieldReactor
    
    private struct Metric {
        static let clearWidthHeight: CGFloat = 20.0
        static let padding: CGFloat = 12.0
        static let fieldTopBottom: CGFloat = 5.0
    }
    
    private struct Color {
        static let fieldBackground: UIColor = UIColor.textFieldBG
        static let placeholder: UIColor = UIColor.textFieldPlaceholder
        static let textField: UIColor = UIColor.title
    }
    
    private struct Font {
        static let textField: UIFont = UIFont.systemFont(ofSize: 16.0)
    }
    
    // MARK: Properties
    public var placeholder: String? {
        set {
            self.textField.placeholder = newValue
        }
        get {
            self.textField.placeholder
        }
    }
    
    public var textColor: UIColor? {
        get {
            self.textField.textColor
        }
        set {
            self.textField.textColor = newValue
        }
    }
    
    public var text: String? {
        get {
            self.textField.text
        }
        set {
            self.textField.text = newValue
        }
    }
    
    var fieldRightToClearButtonConstraint: Constraint?
    var filedRightToSuperViewConstraint: Constraint?
    
    // MARK: UI Views
    private let bgView = EMTNeumorphicView().then {
        $0.neumorphicLayer?.cornerRadius = 12.0
        $0.neumorphicLayer?.depthType = .concave
        $0.neumorphicLayer?.elementDepth = 1
        $0.neumorphicLayer?.elementBackgroundColor = Color.fieldBackground.cgColor
    }
    
    private let clearButton = EMTNeumorphicButton(type: .custom).then {
        $0.setImage(UIImage(named: "textfield_clear"), for: .normal)
        $0.contentVerticalAlignment = .center
        $0.contentHorizontalAlignment = .center
        $0.neumorphicLayer?.elementBackgroundColor = UIColor.white.cgColor
        $0.layer.cornerRadius = Metric.clearWidthHeight / 2.0
        $0.layer.masksToBounds = true
        $0.alpha = 0.0
    }
    
    fileprivate let textField = UITextField().then {
        $0.borderStyle = .none
        $0.textColor = Color.textField
        $0.font = Font.textField
        $0.placeholder = "Placeholder"
    }
    
    // MARK: - Initializing
    override init() {
        super.init()
    }
    
    convenience init(reactor: Reactor) {
        defer { self.reactor = reactor }
        self.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        self.addSubview(bgView)
        self.addSubview(textField)
        self.addSubview(clearButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        clearButton.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Metric.clearWidthHeight)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(Metric.fieldTopBottom)
            make.left.equalTo(Metric.padding)
            make.bottom.equalTo(-Metric.fieldTopBottom)
            fieldRightToClearButtonConstraint = make.right.equalTo(clearButton.snp.left).offset(-Metric.padding).constraint
            filedRightToSuperViewConstraint = make.right.equalTo(-Metric.padding).constraint
        }
        
        fieldRightToClearButtonConstraint?.deactivate()
        filedRightToSuperViewConstraint?.activate()
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        clearButton.rx.tap
            .map { Reactor.Action.clearText }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        textField.rx.controlEvent(.editingDidBegin)
            .map { Reactor.Action.setEditing(true) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        textField.rx.controlEvent(.editingDidEnd)
            .map { Reactor.Action.setEditing(false) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        textField.rx.controlEvent(.editingChanged)
            .map { self.textField.text }
            .map { Reactor.Action.setText($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        textField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] _ in
                self?.textField.resignFirstResponder()
            }).disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.text }
            .bind(to: textField.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isEditing }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isEditing in
                guard let self = self else { return }
                self.setClearButton(isShow: isEditing)
            }).disposed(by: self.disposeBag)
        
        // Configure TextField
        bindTextFieldConfiguration(reactor: reactor)
    }
    
    private func bindTextFieldConfiguration(reactor: Reactor) {
        
        reactor.state.map { $0.placeholder }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] placeholder in
                guard let self = self else { return }
                self.textField.placeholder = placeholder
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.keyboardType }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] type in
                guard let self = self else { return }
                self.textField.keyboardType = type
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.returnKeyType }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] type in
                guard let self = self else { return }
                self.textField.returnKeyType = type
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isSecureTextEntry }
            .distinctUntilChanged()
            .bind(to: textField.rx.isSecureTextEntry)
            .disposed(by: self.disposeBag)
    }
    
    private func setClearButton(isShow: Bool) {
        UIView.animate(withDuration: 0.3, animations: {
            self.clearButton.alpha = isShow ? 1.0 : 0.0
            if isShow {
                self.fieldRightToClearButtonConstraint?.activate()
                self.filedRightToSuperViewConstraint?.deactivate()
            } else {
                self.fieldRightToClearButtonConstraint?.deactivate()
                self.filedRightToSuperViewConstraint?.activate()
            }
            self.layoutIfNeeded()
        })
    }
}

extension Reactive where Base: CommonTextField {
    /// Bindable sink for `isSecureTextEntry` property.
    var isSecureTextEntry: Binder<Bool> {
        return Binder(self.base) { view, isSecureTextEntry in
            view.textField.isSecureTextEntry = isSecureTextEntry
        }
    }
}
