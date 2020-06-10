//
//  TimeLineHeaderView.swift
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

final class TimeLineHeaderView: BaseView, ReactorKit.View {
    
    typealias Reactor = TimeLineHeaderViewReactor
    
    // MARK: Properties
    private struct Metric {
        static let timeLineLeft: CGFloat = 16.0
        static let timeLineTop: CGFloat = 23.0
        
        static let shareButtonRight: CGFloat = 16.0
        static let shareButtonTop: CGFloat = 37.0
        static let shareButtonWidthHeight: CGFloat = 24.0
        
        static let dateTop: CGFloat = 2.0
        static let dateLeft: CGFloat = 16.0
        static let dateRight: CGFloat = 12.0
    }
    
    private struct Color {
        static let background: UIColor = UIColor.baseBG
        static let timeLine: UIColor = UIColor.keyColor
        static let date: UIColor = UIColor.title
    }
    
    private struct Font {
        static let timeLine: UIFont = UIFont.systemFont(ofSize: 13.0)
        static let date: UIFont = UIFont.systemFont(ofSize: 20.0)
    }
    
    // MARK: UI Views
    private let timeLineLabel = UILabel().then {
        $0.font = Font.timeLine
        $0.textColor = Color.timeLine
        $0.text = "timeline"
    }
    
    private let dateLabel = UILabel().then {
        $0.font = Font.date
        $0.textColor = Color.date
        $0.text = "3월 4일의 기분"
    }
    
    private let shareButton = EMTNeumorphicButton(type: .custom).then {
        $0.setImage(UIImage(named: "timeline_share"), for: .normal)
        $0.neumorphicLayer?.elementBackgroundColor = Color.background.cgColor
        $0.neumorphicLayer?.cornerRadius = Metric.shareButtonWidthHeight / 2.0
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
        
        self.addSubview(timeLineLabel)
        self.addSubview(shareButton)
        self.addSubview(dateLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        timeLineLabel.snp.makeConstraints { make in
            make.left.equalTo(Metric.timeLineLeft)
            make.top.equalTo(Metric.timeLineTop)
        }
        
        shareButton.snp.makeConstraints { make in
            make.width.height.equalTo(Metric.shareButtonWidthHeight)
            make.right.equalTo(-Metric.shareButtonRight)
            make.top.equalTo(Metric.shareButtonTop)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLineLabel.snp.bottom).offset(Metric.dateTop)
            make.left.equalTo(Metric.dateLeft)
            make.right.lessThanOrEqualTo(shareButton.snp.left).offset(-Metric.dateRight)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        reactor.state.map { $0.currentDate }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] date in
                guard let self = self else { return }
                let dateString = date.string(dateFormat: "M월 d일")
                self.dateLabel.text = "\(dateString)의 기분"
            }).disposed(by: self.disposeBag)
    }
}
