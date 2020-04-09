//
//  BaseNavigationController.swift
//  TodayMood
//
//  Created by Kanz on 2020/02/26.
//  Copyright © 2020 5boon. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()

    // MARK: - Properties
    var navigationHidden: Bool

    // MARK: - Initialize
    init(rootViewController: UIViewController, navigationBarHidden: Bool = false) {
        self.navigationHidden = navigationBarHidden
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Rx
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.prefersLargeTitles = true
        /*
        self.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Color.title
        ]
         */
        self.setNavigationBarHidden(self.navigationHidden, animated: false)
    }

    deinit {
        logger.verbose("DEINIT: \(self.className)")
    }

    // MARK: - Layout Constraints

    // MARK: - Configure
}
