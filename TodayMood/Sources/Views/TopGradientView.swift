//
//  TopGradientView.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/18.
//

import UIKit

class TopGradientView: BaseView {
    
    var colors: [UIColor]!
    var gradientLayer: CAGradientLayer!
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createGradientLayer()
    }
    
    // MARK: Create Gradient Layer
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = self.colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        // self.layer.addSublayer(layer)
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: [.bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: 30.0, height: 30.0))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        gradientLayer.mask = mask
    }
}
