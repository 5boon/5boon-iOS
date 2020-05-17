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
    }
    
    private struct Color {
        static let label: UIColor = UIColor.white
    }
    
    private struct Font {
        static let dateLabel: UIFont = UIFont.systemFont(ofSize: 14.0)
        static let howFeelLabel: UIFont = UIFont.systemFont(ofSize: 20.0)
    }
    
    // MARK: UI Views
    private let dateLabel = UILabel().then {
        $0.font = Font.dateLabel
        $0.textColor = Color.label
        $0.text = "2020년 3월 5일"
    }
    
    private let howFeelLabel = UILabel().then {
        $0.font = Font.howFeelLabel
        $0.textColor = Color.label
        $0.text = "오늘 지찬규님의\n기분은 최고에요"
        $0.numberOfLines = 2
    }
    
    private let feelIconImageView = UIImageView().then {
        $0.image = UIImage(named: MoodStatusTypes.happy.iconName)
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
        self.addSubview(howFeelLabel)
        self.addSubview(feelIconImageView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(Metric.dateTop)
            make.left.equalTo(Metric.labelLeft)
            make.right.equalTo(-Metric.labelRight)
        }
        
        howFeelLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(Metric.howFeelTop)
            make.left.equalTo(Metric.labelLeft)
            make.right.equalTo(-Metric.labelRight)
        }
        
        feelIconImageView.snp.makeConstraints { make in
            make.right.equalTo(-Metric.feelIconRight)
            make.top.equalTo(Metric.feelIconTop)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        
        // State
        
        // View
    }
}
