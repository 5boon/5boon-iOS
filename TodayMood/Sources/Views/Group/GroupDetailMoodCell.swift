//
//  GroupDetailMoodCell.swift
//  TodayMood
//
//  Created by Kanz on 2020/07/12.
//

import UIKit

import EMTNeumorphicView
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class GroupDetailMoodCell: BaseTableViewCell, ReactorKit.View {
    
    typealias Reactor = GroupDetailMoodCellReactor
    
    // MARK: Properties
    private struct Metric {
        
        static let containerLeftRight: CGFloat = 16.0
        static let containerTopBottom: CGFloat = 8.0
        
        static let summaryWidthHeight: CGFloat = 30.0
        static let summaryLeft: CGFloat = 15.0
        static let summaryTop: CGFloat = 16.0
        
        static let vStackLeftRight: CGFloat = 10.0
        
        static let contentLeftRight: CGFloat = 16.0
        static let contentTopBottom: CGFloat = 16.0
    }
    
    private struct Color {
        static let background: UIColor = UIColor.baseBG
        static let bgViewBackground: UIColor = UIColor.buttonBG
        static let summaryLabel: UIColor = .white
        static let authorNameLabel: UIColor = .title
        static let dateLabel: UIColor = .timeLineSummary
        static let contentLabel: UIColor = .title
    }
    
    private struct Font {
        static let summaryLabel: UIFont = .systemFont(ofSize: 16.0)
        static let authorNameLabel: UIFont = .boldSystemFont(ofSize: 16.0)
        static let dateLabel: UIFont = .systemFont(ofSize: 12.0)
        static let moodLabel: UIFont = .boldSystemFont(ofSize: 12.0)
        static let contentLabel: UIFont = .systemFont(ofSize: 16.0)
    }
    
    // MARK: UI Views
    private let containerView = EMTNeumorphicView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.neumorphicLayer?.cornerRadius = 6.0
        $0.neumorphicLayer?.depthType = .convex
        $0.neumorphicLayer?.elementBackgroundColor = Color.bgViewBackground.cgColor
        $0.neumorphicLayer?.lightShadowOpacity = 0.5
        $0.neumorphicLayer?.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    private let summaryLabel = UILabel().then {
        $0.font = Font.summaryLabel
        $0.textColor = Color.summaryLabel
        $0.layer.cornerRadius = Metric.summaryWidthHeight / 2.0
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.getRandomColor()
        $0.textAlignment = .center
    }
    
    private let vStackView = UIStackView().then {
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private let authorNameLabel = UILabel().then {
        $0.font = Font.authorNameLabel
        $0.textColor = Color.authorNameLabel
    }
    
    private let hStackView = UIStackView().then {
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.spacing = 4.0
    }
    
    private let dateLabel = UILabel().then {
        $0.font = Font.dateLabel
        $0.textColor = Color.dateLabel
        
    }
    
    private let moodLabel = UILabel().then {
        $0.font = Font.moodLabel
    }
    
    private let contentLabel = UILabel().then {
        $0.font = Font.contentLabel
        $0.textColor = Color.contentLabel
        $0.numberOfLines = 0
    }
    
    // MARK: - Initializing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = Color.background
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
        self.contentView.addSubview(containerView)

        containerView.addSubview(summaryLabel)
        containerView.addSubview(vStackView)
        
        vStackView.addArrangedSubview(authorNameLabel)
        vStackView.addArrangedSubview(hStackView)
        
        hStackView.addArrangedSubview(dateLabel)
        hStackView.addArrangedSubview(moodLabel)
        
        containerView.addSubview(contentLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(Metric.containerTopBottom)
            make.bottom.equalTo(-Metric.containerTopBottom)
            make.left.equalTo(Metric.containerLeftRight)
            make.right.equalTo(-Metric.containerLeftRight)
        }
        
        summaryLabel.snp.makeConstraints { make in
            make.left.equalTo(Metric.summaryLeft)
            make.top.equalTo(Metric.summaryTop)
            make.width.height.equalTo(Metric.summaryWidthHeight)
        }
        
        vStackView.snp.makeConstraints { make in
            make.left.equalTo(summaryLabel.snp.right).offset(Metric.vStackLeftRight)
            make.right.lessThanOrEqualTo(-Metric.vStackLeftRight)
            make.centerY.equalTo(summaryLabel.snp.centerY)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(Metric.contentLeftRight)
            make.right.equalTo(-Metric.contentLeftRight)
            make.top.equalTo(vStackView.snp.bottom).offset(Metric.contentTopBottom)
            make.bottom.equalTo(-Metric.contentTopBottom)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        reactor.state.map { $0.mood.userName }
            .map { String($0.prefix(1)) }
            .bind(to: summaryLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.mood.userName }
            .bind(to: authorNameLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.mood.mood?.createdAt }
            .filterNil()
            .map { $0.timeAgo() }
            .bind(to: dateLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.mood.mood?.moodStatus }
            .subscribe(onNext: { [weak self] status in
                guard let self = self, let status = status else { return }
                self.moodLabel.text = status.title
                self.moodLabel.textColor = status.titleColor
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.mood.mood?.summary }
            .filterNil()
            .bind(to: contentLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}
