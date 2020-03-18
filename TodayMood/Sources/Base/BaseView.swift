//
//  BaseView.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/17.
//

import UIKit
import RxSwift

class BaseView: UIView {
    
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    // MARK: add Views,Layout Constraints
    private(set) var didSetupConstraints = false
    
    var disposeBag = DisposeBag()

    override var safeAreaInsets: UIEdgeInsets {
        guard let window = UIApplication.shared.windows.first else { return super.safeAreaInsets }
        return window.safeAreaInsets
    }
    
    init() {
        super.init(frame: .zero)
        self.addViews()
        self.setNeedsUpdateConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        logger.verbose("DEINIT: \(self.className)")
    }
    
    override public func layoutSubviews() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.layoutSubviews()
    }
    
    func addViews() {
        // Override point
    }
    
    func setupConstraints() {
        // Override point
    }
    
    func parentViewController() -> UIViewController {
        var responder: UIResponder? = self
        while !(responder is UIViewController) {
            responder = responder?.next
            if nil == responder {
                break
            }
        }
        return (responder as? UIViewController)!
    }
}

