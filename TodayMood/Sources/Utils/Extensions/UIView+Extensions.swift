//
//  UIView+Extensions.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/23.
//

import UIKit

extension CAGradientLayer {
    func animateChanges(to colors: [UIColor],
                        duration: TimeInterval) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            // Set to final colors when animation ends
            self.colors = colors.map { $0.cgColor }
        })
        let animation = CABasicAnimation(keyPath: "colors")
        animation.duration = duration
        animation.toValue = colors.map { $0.cgColor }
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        add(animation, forKey: "changeColors")
        CATransaction.commit()
    }
}

extension UIView {
    // https://www.andrewcbancroft.com/2014/09/24/slide-in-animation-in-swift/
    func slideFrom(from: CATransitionSubtype, duration: TimeInterval = 0.5, completionDelegate: CAAnimationDelegate? = nil) {
        let slideAnimation = CATransition()
        
        if let delegate = completionDelegate {
            slideAnimation.delegate = delegate
        }
        
        slideAnimation.type = .push
        slideAnimation.subtype = from
        slideAnimation.duration = duration
        slideAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        slideAnimation.fillMode = .removed
        self.layer.add(slideAnimation, forKey: "slideTrasition")
    }
}
