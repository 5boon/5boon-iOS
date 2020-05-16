//
//  MoodWriteGroupListCell.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/11.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class MoodWriteGroupListCell: BaseTableViewCell, ReactorKit.View {
    
    typealias Reactor = MoodWriteGroupListCellReactor
    
    // MARK: Properties
    private struct Metric {
        static let iconLeft: CGFloat = 27.0
        static let iconWidthHeight: CGFloat = 24.0
        static let summaryWidthHeight: CGFloat = 24.0
        static let summaryLeft: CGFloat = 10.0
        static let groupNameLeftRight: CGFloat = 5.0
        static let underLineHeight: CGFloat = 1.0
    }
    
    private struct Color {
        static let summaryBG: UIColor = UIColor.keyColor
        static let summary: UIColor = UIColor.white
        static let groupName: UIColor = UIColor.title
        static let underLine: UIColor = UIColor.underLine
    }
    
    private struct Font {
        static let summary: UIFont = UIFont.systemFont(ofSize: 16.0)
        static let groupName: UIFont = UIFont.systemFont(ofSize: 16.0)
    }
    
    // MARK: UI Views
    private let selectIconImageView = UIImageView().then {
        $0.image = UIImage(named: "publicsetting_checkbox_default")
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
    
    private let groupNameLabel = UILabel().then {
        $0.font = Font.groupName
        $0.textColor = Color.groupName
        $0.text = "도로시와 아이들"
    }
    
    private let underLine = UIView().then {
        $0.backgroundColor = Color.underLine
    }
    
    // MARK: - Initializing
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        
        self.contentView.addSubview(selectIconImageView)
        self.contentView.addSubview(summaryLabel)
        self.contentView.addSubview(groupNameLabel)
        self.addSubview(underLine)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        selectIconImageView.snp.makeConstraints { make in
            make.left.equalTo(Metric.iconLeft)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Metric.iconWidthHeight)
        }
        
        summaryLabel.snp.makeConstraints { make in
            make.left.equalTo(selectIconImageView.snp.right).offset(Metric.summaryLeft)
            make.width.height.equalTo(Metric.summaryWidthHeight)
            make.centerY.equalToSuperview()
        }
        
        groupNameLabel.snp.makeConstraints { make in
            make.left.equalTo(summaryLabel.snp.right).offset(Metric.groupNameLeftRight)
            make.centerY.equalToSuperview()
            make.right.equalTo(-Metric.groupNameLeftRight)
        }
        
        underLine.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(Metric.underLineHeight)
            make.bottom.equalToSuperview()
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
        
        reactor.state.map { $0.isSelected }
            .subscribe(onNext: { [weak self] isSelected in
                guard let self = self else { return }
                let imageName = (isSelected) ? "publicsetting_checkbox_selected" : "publicsetting_checkbox_default"
                self.selectIconImageView.image = UIImage(named: imageName)
            }).disposed(by: self.disposeBag)
    }
}
