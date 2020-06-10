//
//  DotLoadingIndicator.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/26.
//

// https://github.com/pigfly/A_J_Dot_Loading_Indicator

import UIKit

final class DotLoadingIndicator: UIView {
    
    private var dotLayers = [CAShapeLayer]()
    private var dotsScale = 1.3
    
    var dotCounts: Int = 3 {
        didSet {
            layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            dotLayers.removeAll()
            setupLayers()
        }
    }
    
    var dotRadius: CGFloat = 2.0 {
        didSet {
            for layer in dotLayers {
                layer.bounds = CGRect(origin: .zero, size: CGSize(width: dotRadius * 2.0, height: dotRadius * 2.0))
                layer.path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: dotRadius).cgPath
            }
            setNeedsLayout()
        }
    }
    
    var dotsSpacing: CGFloat = 2.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override var tintColor: UIColor! {
        didSet {
            for layer in dotLayers {
                layer.fillColor = tintColor.cgColor
            }
        }
    }
    
    public func startAnimating() {
        var offset: TimeInterval = 0.0
        dotLayers.forEach {
            $0.removeAllAnimations()
            $0.add(scaleAnimation(offset), forKey: "scaleAnimation")
            offset += 0.25
        }
    }

    public func stopAnimating() {
        dotLayers.forEach { $0.removeAllAnimations() }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        setupLayers()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupLayers()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)
        let middle: Int = dotCounts / 2
        for (index, layer) in dotLayers.enumerated() {
            let x = center.x + CGFloat(index - middle) * ((dotRadius*2)+dotsSpacing)
            layer.position = CGPoint(x: x, y: center.y)
        }
        startAnimating()
    }
    
    private func dotLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.bounds = CGRect(origin: .zero, size: CGSize(width: dotRadius*2.0, height: dotRadius*2.0))
        layer.path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: dotRadius).cgPath
        layer.fillColor = tintColor.cgColor
        return layer
    }
    
    private func setupLayers() {
        for _ in 0..<dotCounts {
            let dl = dotLayer()
            dotLayers.append(dl)
            layer.addSublayer(dl)
        }
    }
    
    private func scaleAnimation(_ after: TimeInterval = 0) -> CAAnimationGroup {
        let scaleUp = CABasicAnimation(keyPath: "transform.scale")
        scaleUp.beginTime = after
        scaleUp.fromValue = 1
        scaleUp.toValue = dotsScale
        scaleUp.duration = 0.5
        scaleUp.timingFunction = CAMediaTimingFunction(name: .easeOut)

        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.beginTime = after+scaleUp.duration
        scaleDown.fromValue = dotsScale
        scaleDown.toValue = 1.0
        scaleDown.duration = 0.2
        scaleDown.timingFunction = CAMediaTimingFunction(name: .easeOut)

        let group = CAAnimationGroup()
        group.animations = [scaleUp, scaleDown]
        group.repeatCount = Float.infinity

        let sum = CGFloat(dotCounts)*0.2 + CGFloat(0.4)
        group.duration = CFTimeInterval(sum)

        return group
    }
}
