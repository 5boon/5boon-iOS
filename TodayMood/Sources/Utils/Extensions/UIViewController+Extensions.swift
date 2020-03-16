//
//  UIViewController+Extensions.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/14.
//

import UIKit

extension UIViewController {
    /// Navigation Wrap
    func navigationWrap() -> BaseNavigationController {
        return BaseNavigationController(rootViewController: self)
    }
}
