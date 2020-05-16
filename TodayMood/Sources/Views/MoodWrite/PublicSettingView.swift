//
//  PublicSettingView.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/04/21.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class PublicSettingView: BaseView, ReactorKit.View {
    
    typealias Reactor = PublicSettingViewReactor
    
    private struct Metric {
        static let iconLeft: CGFloat = 15.0
        static let iconRight: CGFloat = 4.0
        static let iconWidthHeight: CGFloat = 14.0
        
        static let arrowRight: CGFloat = 16.0
        static let arrowLeft: CGFloat = 7.0
        static let arrowWidth: CGFloat = 6.0
        static let arrowHeight: CGFloat = 4.0
        
        static let titleTopBottom: CGFloat = 2.0
        
        static let cornerRadius: CGFloat = 15.0
        static let height: CGFloat = 26.0
    }
    
    private struct Color {
        static let title: UIColor = UIColor.title
        static let borderColor: UIColor = UIColor.keyColor
    }
    
    private struct Font {
        static let title: UIFont = UIFont.systemFont(ofSize: 14.0)
    }
    
    // MARK: UI Views
    private let publicIconImageView = UIImageView().then {
        $0.image = UIImage(named: "publicsetting_private")
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Font.title
        $0.textColor = Color.title
        $0.text = "나만 보기"
    }
    
    private let arrowImageView = UIImageView().then {
        $0.image = UIImage(named: "publicsetting_arrow")
    }
    
    // MARK: Properties
    
    // MARK: - Initializing
    override init() {
        super.init()
        self.layer.cornerRadius = Metric.cornerRadius
        self.layer.borderWidth = 1.0
        self.layer.borderColor = Color.borderColor.cgColor
        self.layer.masksToBounds = true
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
        
        self.addSubview(publicIconImageView)
        self.addSubview(titleLabel)
        self.addSubview(arrowImageView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        publicIconImageView.snp.makeConstraints { make in
            make.left.equalTo(Metric.iconLeft)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Metric.iconWidthHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(Metric.titleTopBottom)
            make.bottom.equalTo(-Metric.titleTopBottom)
            make.left.equalTo(publicIconImageView.snp.right).offset(Metric.iconRight)
            make.height.equalTo(Metric.height)
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-Metric.arrowRight)
            make.left.equalTo(titleLabel.snp.right).offset(Metric.arrowLeft)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        reactor.state.map { $0.publicType }
            .subscribe(onNext: { [weak self] type in
                guard let self = self else { return }
                self.publicIconImageView.image = UIImage(named: type.iconImageName)
                self.titleLabel.text = type.title
            }).disposed(by: self.disposeBag)
    }
}

extension Reactive where Base: PublicSettingView {
    var tapped: Observable<Void> {
        return base.rx.tapGesture()
            .when(.recognized)
            .map { _ in Void() }
    }
}
