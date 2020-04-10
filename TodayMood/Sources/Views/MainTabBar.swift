//
//  MainTabBar.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/23.
//

import UIKit

import EMTNeumorphicView
import RxCocoa
import RxSwift

final class MainTabBar: UIView {
    
    private struct Metric {
        static let centerButtonWidthHeight: CGFloat = 64.0
        static let buttonWidthHeight: CGFloat = 44.0
        static let buttonCornerRadius: CGFloat = 20.0
        static let spacing: CGFloat = (UIScreen.main.bounds.width - Metric.centerButtonWidthHeight) / 6.0 / 2.0
        static let buttonTop: CGFloat = 15.0
    }
    
    private struct Color {
        static let background: UIColor = UIColor.baseBG
        static let buttonBackground: UIColor = UIColor.buttonBG
        static let tabBarBackground: UIColor = UIColor.tabBarBG
    }
    
    // MARK: Properies
    var disposeBag = DisposeBag()
    
    private let indexSubject = PublishSubject<Int>()
    var selectedIndexObservable: Observable<Int> {
        return indexSubject.asObservable()
    }
    
    var buttons: [EMTNeumorphicButton] = []
    var selectedIndex: Int = 0 {
        didSet {
            self.indexSubject.onNext(selectedIndex)
        }
    }
    
    // MARK: Views
    private let backgroundView = EMTNeumorphicView().then {
        $0.neumorphicLayer?.depthType = .convex
        $0.neumorphicLayer?.elementBackgroundColor = UIColor.tabBarBG.cgColor
        $0.neumorphicLayer?.cornerType = .all
        $0.neumorphicLayer?.shadowOpacity = 0.1
    }
    
    let centerButton = UIButton(type: .custom).then {
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.backgroundColor = UIColor.keyColor
        $0.layer.cornerRadius = Metric.centerButtonWidthHeight / 2.0
        $0.layer.masksToBounds = true
        $0.setImage(UIImage(named: "ic_draw"), for: .normal)
    }
    
    private let homeButton = EMTNeumorphicButton(type: .custom).then {
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.setImage(UIImage(named: "ic_home"), for: .normal)
        $0.neumorphicLayer?.elementBackgroundColor = Color.buttonBackground.cgColor
        $0.neumorphicLayer?.depthType = .convex
        $0.neumorphicLayer?.cornerRadius = Metric.buttonCornerRadius
        $0.neumorphicLayer?.lightShadowOpacity = 0.5
        $0.neumorphicLayer?.shadowOffset = CGSize(width: 0, height: -5)
        $0.tag = 0
        $0.isSelected = true
    }
    
    private let groupButton = EMTNeumorphicButton(type: .custom).then {
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.setImage(UIImage(named: "ic_group"), for: .normal)
        $0.neumorphicLayer?.elementBackgroundColor = Color.buttonBackground.cgColor
        $0.neumorphicLayer?.depthType = .convex
        $0.neumorphicLayer?.cornerRadius = Metric.buttonCornerRadius
        $0.neumorphicLayer?.lightShadowOpacity = 0.1
        $0.neumorphicLayer?.shadowOffset = CGSize(width: 0, height: 0)
        $0.tag = 1
    }
    
    private let statisticsButton = EMTNeumorphicButton(type: .custom).then {
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.setImage(UIImage(named: "ic_graph"), for: .normal)
        $0.neumorphicLayer?.elementBackgroundColor = Color.buttonBackground.cgColor
        $0.neumorphicLayer?.depthType = .convex
        $0.neumorphicLayer?.cornerRadius = Metric.buttonCornerRadius
        $0.neumorphicLayer?.lightShadowOpacity = 0.1
        $0.neumorphicLayer?.shadowOffset = CGSize(width: 0, height: 0)
        $0.tag = 2
    }
    
    private let settingsButton = EMTNeumorphicButton(type: .custom).then {
        $0.translatesAutoresizingMaskIntoConstraints = true
        $0.setImage(UIImage(named: "ic_setting"), for: .normal)
        $0.neumorphicLayer?.elementBackgroundColor = Color.buttonBackground.cgColor
        $0.neumorphicLayer?.depthType = .convex
        $0.neumorphicLayer?.cornerRadius = Metric.buttonCornerRadius
        $0.neumorphicLayer?.lightShadowOpacity = 0.1
        $0.neumorphicLayer?.shadowOffset = CGSize(width: 0, height: 0)
        $0.tag = 3
    }
    
    // MARK: Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        configureUI()
        binding()
        applyShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubview(backgroundView)
        self.addSubview(centerButton)
        
        self.addSubview(homeButton)
        self.addSubview(groupButton)
        self.addSubview(settingsButton)
        self.addSubview(statisticsButton)
        
        buttons.append(homeButton)
        buttons.append(groupButton)
        buttons.append(settingsButton)
        buttons.append(statisticsButton)
        
        backgroundView.snp.makeConstraints { make in
            make.left.bottom.right.top.equalToSuperview()
        }
        
        centerButton.snp.makeConstraints { make in
            make.width.height.equalTo(Metric.centerButtonWidthHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(-Metric.centerButtonWidthHeight / 2)
        }
        
        homeButton.snp.makeConstraints { make in
            make.width.height.equalTo(Metric.buttonWidthHeight)
            make.top.equalTo(Metric.buttonTop)
            make.left.equalTo(Metric.spacing)
        }
        
        groupButton.snp.makeConstraints { make in
            make.width.height.equalTo(Metric.buttonWidthHeight)
            make.top.equalTo(Metric.buttonTop)
            make.left.equalTo(homeButton.snp.right).offset(Metric.spacing)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.width.height.equalTo(Metric.buttonWidthHeight)
            make.top.equalTo(Metric.buttonTop)
            make.right.equalTo(-Metric.spacing)
        }
        
        statisticsButton.snp.makeConstraints { make in
            make.width.height.equalTo(Metric.buttonWidthHeight)
            make.top.equalTo(Metric.buttonTop)
            make.right.equalTo(settingsButton.snp.left).offset(-Metric.spacing)
        }
    }
    
    private func applyShadow() {
        let path1 = UIBezierPath(roundedRect: backgroundView.bounds, cornerRadius: 0)
        
        let layer1 = CALayer()
        layer1.shadowPath = path1.cgPath
        layer1.shadowColor = UIColor.red.cgColor//UIColor(red: 0.682, green: 0.682, blue: 0.753, alpha: 0.4).cgColor
        layer1.shadowOpacity = 1
        layer1.shadowRadius = 3
        layer1.shadowOffset = CGSize(width: 1.5, height: 1.5)
        layer1.bounds = backgroundView.bounds
        layer1.position = backgroundView.center
        
        backgroundView.layer.addSublayer(layer1)
        
        let path2 = UIBezierPath(roundedRect: backgroundView.bounds, cornerRadius: 0)
        
        let layer2 = CALayer()
        layer2.shadowPath = path2.cgPath
        layer2.shadowColor = UIColor.blue.cgColor//UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        layer2.shadowOpacity = 1
        layer2.shadowRadius = 3
        layer2.shadowOffset = CGSize(width: -1, height: -1)
        layer2.bounds = backgroundView.bounds
        layer2.position = backgroundView.center
        
        backgroundView.layer.addSublayer(layer2)
    }
    
    private func binding() {
        
        let homeTap = homeButton.rx.tap
            .map { self.homeButton.tag }
        
        let groupTap = groupButton.rx.tap
            .map { self.groupButton.tag }
        
        let statisticsTap = statisticsButton.rx.tap
            .map { self.statisticsButton.tag }
        
        let settingsTap = settingsButton.rx.tap
            .map { self.settingsButton.tag }
        
        let buttonTaps: Observable<Int> = Observable.merge([homeTap, groupTap, statisticsTap, settingsTap])
        buttonTaps
            .subscribe(onNext: { [weak self] selectedIndex in
                guard let self = self else { return }
                self.indexSubject.onNext(selectedIndex)
                self.buttons.forEach { $0.isSelected = $0.tag == selectedIndex }
            }).disposed(by: self.disposeBag)
    }
}

extension Reactive where Base: MainTabBar {
    var selectedIndex: Observable<Int> {
        return base.selectedIndexObservable
    }
    
    var centerButtonTap: ControlEvent<Void> {
        return base.centerButton.rx.tap
    }
}
