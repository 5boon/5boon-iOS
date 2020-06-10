//
//  PublicGroupCell.swift
//  TodayMood
//
//  Created by Kanz on 2020/06/10.
//

import UIKit

import EMTNeumorphicView
import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class PublicGroupCell: BaseTableViewCell, ReactorKit.View {
    
    typealias Reactor = PublicGroupCellReactor
    
    // MARK: Properties
    private struct Metric {
        static let containerLeft: CGFloat = 16.0
        static let containerRight: CGFloat = 16.0
        static let containerTopBottom: CGFloat = 8.0
        
        static let summaryWidthHeight: CGFloat = 31.0
        static let summaryLeft: CGFloat = 10.0
        
        static let textLeftRight: CGFloat = 10.0
        
        static let minHeight: CGFloat = 80.0
    }
    
    private struct Color {
        static let summaryBG: UIColor = UIColor.keyColor
        static let summary: UIColor = UIColor.white
        static let groupMemberCount: UIColor = UIColor.timeLineSummary
        static let groupName: UIColor = UIColor.title
        static let bgViewBackground: UIColor = UIColor.buttonBG
        static let background: UIColor = UIColor.baseBG
    }
    
    private struct Font {
        static let groupMemberCount: UIFont = UIFont.systemFont(ofSize: 12.0)
        static let groupName: UIFont = UIFont.boldSystemFont(ofSize: 16.0)
        static let summary: UIFont = UIFont.systemFont(ofSize: 16.0)
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
        $0.font = Font.summary
        $0.textColor = Color.summary
        $0.backgroundColor = Color.summaryBG
        $0.textAlignment = .center
        $0.layer.cornerRadius = Metric.summaryWidthHeight / 2.0
        $0.layer.masksToBounds = true
        $0.text = "도"
    }
    
    private let textContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let groupMemberCountLabel = UILabel().then {
        $0.font = Font.groupMemberCount
        $0.textColor = Color.groupMemberCount
        $0.text = "지찬규님 외 5명 참여"
    }
    
    private let groupNameLabel = UILabel().then {
        $0.font = Font.groupName
        $0.textColor = Color.groupName
        $0.text = "제이와 아이들"
    }
    
    private let heightView = UIView().then {
        $0.backgroundColor = .clear
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
        
        containerView.addSubview(heightView)
        
        containerView.addSubview(summaryLabel)
        containerView.addSubview(textContainerView)
        textContainerView.addSubview(groupMemberCountLabel)
        textContainerView.addSubview(groupNameLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        containerView.snp.makeConstraints { make in
            make.top.equalTo(Metric.containerTopBottom)
            make.bottom.equalTo(-Metric.containerTopBottom)
            make.left.equalTo(Metric.containerLeft)
            make.right.equalTo(-Metric.containerRight)
        }
        
        heightView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(Metric.minHeight)
        }
        
        summaryLabel.snp.makeConstraints { make in
            make.left.equalTo(Metric.summaryLeft)
            make.width.height.equalTo(Metric.summaryWidthHeight)
            make.centerY.equalToSuperview()
        }
        
        textContainerView.snp.makeConstraints { make in
            make.left.equalTo(summaryLabel.snp.right).offset(Metric.textLeftRight)
            make.right.equalTo(-Metric.textLeftRight)
            make.centerY.equalToSuperview()
        }
        
        groupMemberCountLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        groupNameLabel.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(groupMemberCountLabel.snp.bottom)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        reactor.state.map { $0.group.moodGroup.title }
            .map { String($0.prefix(1)) }
            .bind(to: summaryLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.group.moodGroup.title }
            .bind(to: groupNameLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}
