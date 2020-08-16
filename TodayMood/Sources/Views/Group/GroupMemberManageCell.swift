//
//  GroupMemberManageCell.swift
//  TodayMood
//
//  Created by Kanz on 2020/07/11.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class GroupMemberManageCell: BaseTableViewCell, ReactorKit.View {
    
    typealias Reactor = GroupMemberManageCellReactor
    
    // MARK: Properties
    private struct Metric {
        static let summaryLeft: CGFloat = 25.0
        static let summaryWidthHeight: CGFloat = 30.0
        
        static let nameLeft: CGFloat = 10.0
        static let nameRight: CGFloat = 25.0
    }
    
    private struct Color {
        static let summary: UIColor = UIColor.white
        static let name: UIColor = UIColor.title
    }
    
    private struct Font {
        static let summary: UIFont = UIFont.systemFont(ofSize: 16.0)
        static let name: UIFont = UIFont.systemFont(ofSize: 14.0)
    }
    
    // MARK: UI Views
    
    private let summaryLabel = UILabel().then {
        $0.font = Font.summary
        $0.textColor = Color.summary
        $0.layer.cornerRadius = Metric.summaryWidthHeight / 2.0
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.getRandomColor()
        $0.textAlignment = .center
    }
     
    private let nameLabel = UILabel().then {
        $0.font = Font.name
        $0.textColor = Color.name
    }
    
    // MARK: - Initializing
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        self.contentView.addSubview(summaryLabel)
        self.contentView.addSubview(nameLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        summaryLabel.snp.makeConstraints { make in
            make.left.equalTo(Metric.summaryLeft)
            make.width.height.equalTo(Metric.summaryWidthHeight)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(summaryLabel.snp.right).offset(Metric.nameLeft)
            make.centerY.equalToSuperview()
            make.right.equalTo(-Metric.nameRight)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        reactor.state.map { $0.user.name }
            .map { String($0.prefix(1)) }
            .bind(to: summaryLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.user.name }
            .bind(to: nameLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}
