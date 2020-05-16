//
//  HomeTimeLineCell.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/17.
//

import UIKit

import EMTNeumorphicView
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class HomeTimeLineCell: BaseTableViewCell, ReactorKit.View {
    
    typealias Reactor = HomeTimeLineCellReactor
    
    private struct Metric {
        static let containerLeft: CGFloat = 38.0
        static let containerRight: CGFloat = 37.0
        static let containerTopBottom: CGFloat = 8.0
        
        static let clockWidthHeight: CGFloat = 21.0
        static let clockLeft: CGFloat = 16.0
        static let clockTop: CGFloat = 17.0
        static let clockRight: CGFloat = 6.0
        
        static let moreButtonWidthHeight: CGFloat = 24.0
        static let moreButtonRight: CGFloat = 8.0
        static let moreButtonLeft: CGFloat = 8.0
        
        static let timeLabelTop: CGFloat = 16.0
        static let moodLabelTop: CGFloat = 16.0
        static let moodLabelLeft: CGFloat = 4.0
        static let summaryTopBottom: CGFloat = 16.0
        static let summaryLeftRight: CGFloat = 16.0
        
        static let minHeight: CGFloat = 117.0
    }
    
    private struct Color {
        static let timeLabel: UIColor = UIColor.title
        static let summaryLabel: UIColor = UIColor.timeLineSummary
        static let bgViewBackground: UIColor = UIColor.buttonBG
        static let background: UIColor = UIColor.baseBG
    }
    
    private struct Font {
        static let timeLabel: UIFont = UIFont.systemFont(ofSize: 14.0)
        static let summaryLabel: UIFont = UIFont.systemFont(ofSize: 14.0)
        static let moodLabel: UIFont = UIFont.boldSystemFont(ofSize: 14.0)
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
    
    private let clockImageView = UIImageView().then {
        $0.image = UIImage(named: "timeline_clock")
    }
    
    private let moreButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "timeline_more"), for: .normal)
    }
    
    private let timeLabel = UILabel().then {
        $0.font = Font.timeLabel
        $0.textColor = Color.timeLabel
        $0.text = "2시간 전"
    }
    
    private let moodLabel = UILabel().then {
        $0.font = Font.moodLabel
    }
    
    private let summaryLabel = UILabel().then {
        $0.font = Font.summaryLabel
        $0.textColor = Color.summaryLabel
        $0.numberOfLines = 2
    }

    private let heightView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: Properties
//    override var isHighlighted: Bool {
//        didSet {
//            self.containerView.neumorphicLayer?.depthType = isHighlighted ? .concave : .convex
//        }
//    }
    
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
        
        containerView.addSubview(heightView)
        containerView.addSubview(clockImageView)
        containerView.addSubview(moreButton)
        
        containerView.addSubview(timeLabel)
        containerView.addSubview(moodLabel)
        containerView.addSubview(summaryLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(Metric.containerTopBottom)
            make.bottom.equalTo(-Metric.containerTopBottom)
            make.left.equalTo(Metric.containerLeft)
            make.right.equalTo(-Metric.containerRight)
        }
        
        clockImageView.snp.makeConstraints { make in
            make.top.equalTo(Metric.clockTop)
            make.left.equalTo(Metric.clockLeft)
            make.width.height.equalTo(Metric.clockWidthHeight)
        }
        
        moreButton.snp.makeConstraints { make in
            make.top.equalTo(Metric.moodLabelTop)
            make.width.height.equalTo(Metric.moreButtonWidthHeight)
            make.right.equalTo(-Metric.moreButtonRight)
        }
        
        timeLabel.snp.makeConstraints { make in
//            make.top.equalTo(Metric.timeLabelTop)
            make.left.equalTo(clockImageView.snp.right).offset(Metric.clockRight)
            make.centerY.equalTo(clockImageView.snp.centerY)
        }
        
        moodLabel.snp.makeConstraints { make in
//            make.top.equalTo(Metric.moodLabelTop)
            make.left.equalTo(timeLabel.snp.right).offset(Metric.moodLabelLeft)
            make.right.lessThanOrEqualTo(moreButton.snp.left).offset(-Metric.moreButtonRight)
            make.centerY.equalTo(clockImageView.snp.centerY)
        }
        
        summaryLabel.snp.makeConstraints { make in
            make.top.equalTo(moodLabel.snp.bottom).offset(Metric.summaryTopBottom)
            make.left.equalTo(Metric.summaryLeftRight)
            make.right.equalTo(-Metric.summaryLeftRight)
            make.bottom.equalTo(-Metric.summaryTopBottom)
        }
        
        heightView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(Metric.minHeight)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        reactor.state.map { $0.mood.moodStatus }
            .subscribe(onNext: { [weak self] status in
                guard let self = self else { return }
                self.moodLabel.textColor = status.titleColor
                self.moodLabel.text = status.title
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.mood.summary }
            .bind(to: summaryLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    
}
