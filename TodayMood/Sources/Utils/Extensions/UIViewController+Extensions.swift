//
//  UIViewController+Extensions.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/14.
//

import SafariServices
import UIKit

extension UIViewController {
    /// Navigation Wrap
    func navigationWrap() -> BaseNavigationController {
        return BaseNavigationController(rootViewController: self)
    }
}

extension UIViewController {
    /// SFSafariViewController
    func pushToSFSafariWeb(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
}
