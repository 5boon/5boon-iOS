//
//  SignUpFinishedViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/02.
//

import UIKit

import ReactorKit
import ReusableKit
import RxCocoa
import RxSwift
import RxViewController
import SnapKit
import Then

final class SignUpFinishedViewController: BaseViewController, View {
    
    typealias Reactor = SignUpReactor
    
    private struct Metric {
        static let progressWidthHeight: CGFloat = 35.0
        static let progressLargeWidthHeight: CGFloat = 57.0
        static let progressCenterTop: CGFloat = 130.0
        static let progressCenterLeftRight: CGFloat = 44.0
        static let progressCenterArrowLeftRight: CGFloat = 10.0
        
        static let progressArrowWidthHeight: CGFloat = 24.0
        
        static let titleTop: CGFloat = 16.0
    }
    
    private struct Color {
        static let progressOn: UIColor = UIColor.progressOn
        static let progressOff: UIColor = UIColor.progressOff
        static let title: UIColor = UIColor.keyColor
    }
    
    private struct Font {
        static let title: UIFont = UIFont.boldSystemFont(ofSize: 20.0)
    }
    
    // MARK: Properties
    var centerConstraint: Constraint?
    var moveTopConstraint: Constraint?
    var bounceCount: Int = 0
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    private let presentMainScreen: () -> Void
    
    // MARK: Views
    private let progressFirst = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "ic_check")
        $0.layer.cornerRadius = Metric.progressWidthHeight / 2.0
        $0.layer.masksToBounds = true
        $0.backgroundColor = Color.progressOn
        $0.contentMode = .center
    }
    
    private let arrowFirst = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "ic_double_greyarrow_right")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Color.progressOn
    }
    
    private let progressSecond = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "ic_check")
        $0.layer.cornerRadius = Metric.progressWidthHeight / 2.0
        $0.layer.masksToBounds = true
        $0.backgroundColor = Color.progressOn
        $0.contentMode = .center
    }
    
    private let arrowSecond = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "ic_double_greyarrow_right")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Color.progressOn
    }
    
    private let progressThird = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "ic_check")
        $0.layer.cornerRadius = Metric.progressWidthHeight / 2.0
        $0.layer.masksToBounds = true
        $0.backgroundColor = Color.progressOn
        $0.contentMode = .center
    }
    
    private let titleLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = Font.title
        $0.textColor = Color.title
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.text = "오늘의 기분\n계정이 생성되었습니다!"
        $0.alpha = 0.0
    }
    
    private let gradientView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alpha = 0.0
        $0.layer.cornerRadius = Metric.progressArrowWidthHeight / 2
        $0.layer.masksToBounds = true
    }
    
    private let hiddenGradientView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alpha = 0.0
    }
    
    // MARK: - Initializing
    init(reactor: Reactor,
         presentMainScreen: @escaping () -> Void) {
        defer { self.reactor = reactor }
        self.presentMainScreen = presentMainScreen
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createGradientLayer()
    }
    
    // MARK: - UI Setup
    override func addViews() {
        super.addViews()
        self.view.addSubview(arrowFirst)
        self.view.addSubview(arrowSecond)
        
        self.view.addSubview(progressFirst)
        self.view.addSubview(progressThird)
        self.view.addSubview(progressSecond)
        
        self.view.addSubview(titleLabel)
        
        self.view.addSubview(gradientView)
        
        self.view.addSubview(hiddenGradientView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        progressSecond.snp.makeConstraints { make in
            make.top.equalTo(Metric.progressCenterTop)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Metric.progressWidthHeight)
        }
        
        arrowFirst.snp.makeConstraints { make in
            make.right.equalTo(progressSecond.snp.left).offset(-Metric.progressCenterArrowLeftRight)
            make.width.height.equalTo(Metric.progressArrowWidthHeight)
            make.centerY.equalTo(progressSecond.snp.centerY)
        }
        
        arrowSecond.snp.makeConstraints { make in
            make.left.equalTo(progressSecond.snp.right).offset(Metric.progressCenterArrowLeftRight)
            make.width.height.equalTo(Metric.progressArrowWidthHeight)
            make.centerY.equalTo(progressSecond.snp.centerY)
        }
        
        progressFirst.snp.makeConstraints { make in
            make.width.height.equalTo(Metric.progressWidthHeight)
            make.right.equalTo(progressSecond.snp.left).offset(-Metric.progressCenterLeftRight)
            make.centerY.equalTo(progressSecond.snp.centerY)
        }
        
        progressThird.snp.makeConstraints { make in
            make.width.height.equalTo(Metric.progressWidthHeight)
            make.centerY.equalTo(progressSecond.snp.centerY)
            make.left.equalTo(progressSecond.snp.right).offset(Metric.progressCenterLeftRight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressSecond.snp.bottom).offset(Metric.titleTop)
            make.centerX.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
//            make.height.equalTo(10.0)
//            make.left.equalTo((screenWidth-10)/2)
//            make.right.equalTo(-(screenWidth-10)/2)
//            make.width.equalTo(10.0)
            make.width.height.equalTo(Metric.progressArrowWidthHeight)
        }
        
        hiddenGradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func createGradientLayer() {
        let colors = [UIColor.gradientTop, UIColor.gradientBottom]
        let layer = CAGradientLayer()
        layer.frame = self.gradientView.bounds
        layer.colors = colors.map { $0.cgColor }
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.gradientView.layer.addSublayer(layer)
//        self.gradientView.layer.insertSublayer(layer, at: 0)
        
//        let path = UIBezierPath(roundedRect: self.gradientView.bounds,
//                                byRoundingCorners: [.bottomLeft, .bottomRight],
//                                cornerRadii: CGSize(width: 30.0, height: 30.0))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        layer.mask = mask

        let hiddenLayer = CAGradientLayer()
        hiddenLayer.frame = self.hiddenGradientView.bounds
        hiddenLayer.colors = colors.map { $0.cgColor }
        hiddenLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        hiddenLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.hiddenGradientView.layer.addSublayer(hiddenLayer)
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        self.rx.viewDidAppear
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.centerAlignAnimation()
            }).disposed(by: self.disposeBag)
        
        // State
        
        // View
    }
    
    private func centerAlignAnimation() {
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.arrowFirst.alpha = 0.0
            self.arrowSecond.alpha = 0.0
            
            self.progressFirst.snp.remakeConstraints { make in
                make.center.equalTo(self.progressSecond.snp.center)
            }
            self.progressThird.snp.remakeConstraints { make in
                make.center.equalTo(self.progressSecond.snp.center)
            }
            self.progressSecond.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            
            self.view.layoutIfNeeded()
            
        }) { finished in
            if finished {
                self.progressFirst.removeFromSuperview()
                self.progressThird.removeFromSuperview()
                self.moveDownAnimation()
            }
        }
    }
    
    private func moveDownAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.progressSecond.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.height.equalTo(Metric.progressWidthHeight)
                make.centerY.equalToSuperview()
            }
            self.progressSecond.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.view.layoutIfNeeded()
        }) { finished in
            if finished {
                self.bounceAnimation()
            }
        }
    }
    
    private func bounceAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.progressSecond.snp.remakeConstraints { make in
                make.centerX.equalToSuperview()
                make.width.height.equalTo(Metric.progressWidthHeight)
                make.centerY.equalToSuperview().offset(-30.0)
            }
            self.view.layoutIfNeeded()
        }) { finished in
            self.titleLabel.alpha = 1.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.progressSecond.alpha = 0.0
                self.titleLabel.alpha = 0.0
                self.gradientView.alpha = 1.0
                self.spreadAnimation()
            }
        }
    }
    
    private func spreadAnimation() {
        let layerAnimation = CABasicAnimation(keyPath: "transform.scale")
        layerAnimation.fromValue = 1
        layerAnimation.toValue = 40
        layerAnimation.isAdditive = false
        layerAnimation.duration = 1.0
        layerAnimation.fillMode = .forwards
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.delegate = self
        
        self.gradientView.layer.add(layerAnimation, forKey: "growingAnimation")
    }
}

extension SignUpFinishedViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.hiddenGradientView.alpha = 1.0
            self.presentMainScreen()
        }
    }
}
