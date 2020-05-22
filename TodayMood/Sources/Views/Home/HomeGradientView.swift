//
//  HomeGradientView.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/17.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class HomeGradientView: TopGradientView, ReactorKit.View {
    
    typealias Reactor = HomeGradientViewReactor
    
    private struct Metric {
        static let dateTop: CGFloat = 116.0
        static let labelLeft: CGFloat = 62.0
        static let labelRight: CGFloat = 28.0
        static let howFeelTop: CGFloat = 16.0
        static let feelIconTop: CGFloat = 120.0
        static let feelIconRight: CGFloat = 30.0
        
        static let arrowBottom: CGFloat = 85.0
        static let arrowLeft: CGFloat = 27.0
        static let arrowRight: CGFloat = 27.0
    }
    
    private struct Color {
        static let label: UIColor = UIColor.white
    }
    
    private struct Font {
        static let dateLabel: UIFont = UIFont.systemFont(ofSize: 14.0)
        static let regular: UIFont = UIFont.systemFont(ofSize: 20.0)
        static let bold: UIFont = UIFont.boldSystemFont(ofSize: 20.0)
    }
    
    // MARK: UI Views
    private let dateLabel = UILabel().then {
        $0.font = Font.dateLabel
        $0.textColor = Color.label
        $0.text = "2020년 3월 5일"
    }
    
    private let firstLineLabel = UILabel().then {
        $0.font = Font.regular
        $0.textColor = Color.label
        $0.text = "어서오세요. 지찬규님"
    }
    
    private let secondLineLabel = UILabel().then {
        $0.font = Font.bold
        $0.textColor = Color.label
        $0.text = "오늘의 기분을 등록해주세요."
    }
    
    private let feelIconImageView = UIImageView().then {
        $0.image = UIImage(named: MoodStatusTypes.good.iconName)
    }
    
    fileprivate let prevButton = UIButton().then {
        $0.setImage(UIImage(named: "home_arrow_left"), for: .normal)
    }
    
    fileprivate let nextButton = UIButton().then {
        $0.setImage(UIImage(named: "home_arrow_right"), for: .normal)
    }
    
    // MARK: Properties
    
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
        
        self.addSubview(dateLabel)
        self.addSubview(firstLineLabel)
        self.addSubview(secondLineLabel)
        self.addSubview(feelIconImageView)
        
        self.addSubview(prevButton)
        self.addSubview(nextButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(Metric.dateTop)
            make.left.equalTo(Metric.labelLeft)
            make.right.equalTo(-Metric.labelRight)
        }
        
        firstLineLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Metric.howFeelTop)
            make.left.equalTo(Metric.labelLeft)
            make.right.equalTo(-Metric.labelRight)
        }
        
        secondLineLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLineLabel.snp.bottom)
            make.left.equalTo(Metric.labelLeft)
            make.right.equalTo(-Metric.labelRight)
        }
        
        feelIconImageView.snp.makeConstraints { make in
            make.right.equalTo(-Metric.feelIconRight)
            make.top.equalTo(Metric.feelIconTop)
        }
        
        prevButton.snp.makeConstraints { make in
            make.bottom.equalTo(-Metric.arrowBottom)
            make.left.equalTo(Metric.arrowLeft)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(-Metric.arrowBottom)
            make.right.equalTo(-Metric.arrowRight)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        reactor.state.map { ($0.user, $0.latestMood) }
            .subscribe(onNext: { [weak self] (user, latestMood) in
                guard let self = self, let userName = user?.userName else { return }
                if let mood = latestMood {
                    self.firstLineLabel.text = "오늘 \(userName)님의"
                    self.firstLineLabel.font = Font.regular
                    self.secondLineLabel.text = "기분은 \(mood.moodStatus.title)"
                    self.secondLineLabel.font = Font.bold
                } else {
                    self.firstLineLabel.text = "어서오세요. \(userName)님"
                    self.firstLineLabel.font = Font.bold
                    self.secondLineLabel.text = "오늘의 기분을 등록해 주세요."
                    self.secondLineLabel.font = Font.regular
                }
                self.animation()
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.currentDate }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] date in
                guard let self = self else { return }
                let dateString = date.string(dateFormat: "yyyy년 M월 d일")
                self.dateLabel.text = dateString
            }).disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isEnableMoveToPrev }
            .map { !$0 }
            .bind(to: prevButton.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isEnableMoveToNext }
            .map { !$0 }
            .bind(to: nextButton.rx.isHidden)
            .disposed(by: self.disposeBag)
    }
    
    private func animation() {
        guard let reactor = self.reactor, let latestMood = reactor.currentState.latestMood else { return }
        self.gradientLayer.animateChanges(to: [latestMood.moodStatus.gradientTop, latestMood.moodStatus.gradientBottom],
                                          duration: 1.0)
    }
}

// MARK: Reactive Extension
extension Reactive where Base: HomeGradientView {
    var prevTapped: ControlEvent<Void> {
        return base.prevButton.rx.tap
    }
    
    var nextTapped: ControlEvent<Void> {
        return base.nextButton.rx.tap
    }
    
    var prevGesture: Observable<Void> {
        return base.rx.swipeGesture(.right)
            .when(.recognized)
            .filter { _ in self.base.reactor?.currentState.isEnableMoveToPrev == true }
            .map { _ in Void() }
    }
    
    var nextGesture: Observable<Void> {
        return base.rx.swipeGesture(.left)
            .when(.recognized)
            .filter { _ in self.base.reactor?.currentState.isEnableMoveToNext == true }
            .map { _ in Void() }
    }
}
