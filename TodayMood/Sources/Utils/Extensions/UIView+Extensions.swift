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
