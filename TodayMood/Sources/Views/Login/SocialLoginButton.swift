//
//  SocialLoginButton.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/27.
//

import UIKit

import ReactorKit
import RxCocoa
import RxGesture
import RxSwift
import SnapKit
import Then

final class SocialLoginButton: BaseView, ReactorKit.View {
    
    typealias Reactor = SocialLoginButtonReactor
    
    private struct Metric {
        static let iconWidthHeight: CGFloat = 18.0
        
        static let titleLeft: CGFloat = 8.0
        static let titleRight: CGFloat = 16.0
        
        static let underLineHeight: CGFloat = 1.0
    }
    
    private struct Color {
        static let title: UIColor = UIColor.white
        static let underLine: UIColor = UIColor(white: 1.0, alpha: 0.4)
    }
    
    private struct Font {
        static let title: UIFont = UIFont.systemFont(ofSize: 16.0)
    }
    
    // MARK: Properties
    
    // MARK: UI Views
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel().then {
        $0.font = Font.title
        $0.textColor = Color.title
    }
    private let arrowImageView = UIImageView().then {
        $0.image = UIImage(named: "ic_arrow")
    }
    private let underLine = UIView().then {
        $0.backgroundColor = Color.underLine
    }
    
    fileprivate let button = UIButton()
    
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
        self.addSubview(iconImageView)
        self.addSubview(arrowImageView)
        self.addSubview(titleLabel)
        self.addSubview(underLine)
        self.addSubview(button)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(Metric.iconWidthHeight)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(iconImageView.snp.right).offset(Metric.titleLeft)
            make.right.equalTo(arrowImageView.snp.left).offset(-Metric.titleRight)
        }
        
        underLine.snp.makeConstraints { make in
            make.height.equalTo(Metric.underLineHeight)
            make.left.right.bottom.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: Reactor) {
        
        reactor.state.map { $0.type.iconImageName }
            .map { UIImage(named: $0) }
            .bind(to: iconImageView.rx.image)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.type.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isShowUnderLine }
            .map { !$0 }
            .bind(to: underLine.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
}

// MARK: Reactive Extensions
extension Reactive where Base: SocialLoginButton {
    var tap: ControlEvent<Void> {
//        return base.rx.tapGesture()
//            .when(.recognized)
//            .map { _ in Void() }
        return base.button.rx.tap
    }
}
