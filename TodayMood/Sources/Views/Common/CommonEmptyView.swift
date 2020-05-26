//
//  CommonEmptyView.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/26.
//

import UIKit

import RxCocoa
import RxSwift

final class CommonEmptyView: BaseView {
    
    private struct Metric {
        static let titleTop: CGFloat = 20.0
        static let titleLeftRight: CGFloat = 12.0
        static let imageWidth: CGFloat = 85.0
        static let imageHeight: CGFloat = 49.0
        static let offset: CGFloat = -30.0
    }
    
    private struct Font {
        static let title: UIFont = UIFont.boldSystemFont(ofSize: 16.0)
    }
    
    private struct Color {
        static let title: UIColor = UIColor.emptyTitle
    }
    
    private let contentView = UIView()
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: "timeline_empty")
    }
    
    private let titleLabel = UILabel().then {
        $0.font = Font.title
        $0.textColor = Color.title
        $0.textAlignment = .center
//        $0.text = "등록된 오늘의 기분이 없습니다."
    }
    
    var type: EmptyTypes! {
        didSet {
            titleLabel.text = type.message
            imageView.image = UIImage(named: type.imageName)
        }
    }
    
    override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addViews() {
        super.addViews()
        self.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(Metric.offset)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(Metric.imageWidth)
            make.height.equalTo(Metric.imageHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(Metric.titleLeftRight)
            make.right.equalTo(-Metric.titleLeftRight)
            make.top.equalTo(imageView.snp.bottom).offset(Metric.titleTop)
        }
    }
}
