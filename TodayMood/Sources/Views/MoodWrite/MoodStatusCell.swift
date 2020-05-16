//
//  MoodStatusCell.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/20.
//

import UIKit

import EMTNeumorphicView
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class MoodStatusCell: BaseTableViewCell, ReactorKit.View {
    
    typealias Reactor = MoodStatusCellReactor
    
    // MARK: Properties
    private struct Metric {
        static let bgLeftRight: CGFloat = 40.0
        static let bgTop: CGFloat = 8.0
        static let bgBottom: CGFloat = 7.0
        static let bgHeight: CGFloat = 75.0
        
        static let iconWidthHeight: CGFloat = 50.0
        static let iconLeft: CGFloat = 66.0
        static let titleLeft: CGFloat = 20.0
        static let titleRight: CGFloat = 12.0
    }
    
    private struct Color {
        static let background: UIColor = UIColor.baseBG
        static let title: UIColor = UIColor.title
        static let bgViewBackground: UIColor = UIColor.buttonBG
    }
    
    private struct Font {
        static let title: UIFont = UIFont.systemFont(ofSize: 16.0)
    }
    
    // MARK: UI Views
    let bgView = EMTNeumorphicView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.neumorphicLayer?.cornerRadius = 30.0
        $0.neumorphicLayer?.depthType = .convex
        $0.neumorphicLayer?.elementBackgroundColor = Color.bgViewBackground.cgColor
        $0.neumorphicLayer?.lightShadowOpacity = 0.5
        $0.neumorphicLayer?.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel().then {
        $0.font = Font.title
        $0.textColor = Color.title
        // $0.text = "가나다라"
    }
    
    // MARK: - Initializing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = Color.background
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        
        self.contentView.addSubview(bgView)
        bgView.addSubview(iconImageView)
        bgView.addSubview(titleLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        bgView.snp.makeConstraints { make in
            make.top.equalTo(Metric.bgTop)
            make.left.equalTo(Metric.bgLeftRight)
            make.right.equalTo(-Metric.bgLeftRight)
            make.bottom.equalTo(-Metric.bgBottom)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(Metric.iconLeft)
            make.width.height.equalTo(Metric.iconWidthHeight)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(Metric.titleLeft)
            make.right.equalTo(-Metric.titleRight)
            make.top.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        reactor.state.map { $0.status.iconName }
            .map { UIImage(named: $0) }
            .bind(to: iconImageView.rx.image)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.status.title }
            .bind(to: titleLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isSelected }
            .subscribe(onNext: { [weak self] isSelected in
                guard let self = self else { return }
                self.bgView.neumorphicLayer?.depthType = isSelected ? .concave : .convex
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.status.titleColor }
            .subscribe(onNext: { [weak self] color in
                guard let self = self else { return }
                self.titleLabel.textColor = color
            }).disposed(by: self.disposeBag)
    }
    
    // MARK: Update EMTNeumorphicView layer
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        bgView.neumorphicLayer?.update()
//    }
    
//    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        super.setHighlighted(highlighted, animated: animated)
//        bgView.neumorphicLayer?.depthType = highlighted ? .concave : .convex
//    }
}
