//
//  BaseViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/02/26.
//  Copyright © 2020 5boon. All rights reserved.
//

import UIKit

import Pure
import RxSwift

class BaseViewController: UIViewController {

    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    // MARK: - Properties
    var safeAreaInsets: UIEdgeInsets {
        guard let window = UIApplication.shared.windows.first else { return self.view.safeAreaInsets }
        return window.safeAreaInsets
    }
    private(set) var didSetupConstraints = false

    // MARK: - Initialize
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    // MARK: - Rx
    var disposeBag = DisposeBag()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.baseBG

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        self.addViews()
        self.view.setNeedsUpdateConstraints()
    }

    deinit {
        logger.verbose("DEINIT: \(self.className)")
    }

    // MARK: - Layout Constraints
    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    // MARK: - Configure
    func addViews() { }

    func setupConstraints() { }

}
