//
//  TopGradientView.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/18.
//

import UIKit

class TopGradientView: BaseView {
    
    var colors: [UIColor]!
    
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
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.colors = self.colors.map { $0.cgColor }
        layer.startPoint = CGPoint(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        // self.layer.addSublayer(layer)
        self.layer.insertSublayer(layer, at: 0)
        
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: [.bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: 30.0, height: 30.0))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
