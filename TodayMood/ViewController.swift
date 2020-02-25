//
//  ViewController.swift
//  TodayMood
//
//  Created by Kanz on 2020/02/25.
//  Copyright © 2020 5boon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        
        // Now let’s log!
        log.verbose("not so important")  // prio 1, VERBOSE in silver
        log.debug("something to debug")  // prio 2, DEBUG in green
        log.info("a nice information")   // prio 3, INFO in blue
        log.warning("oh no, that won’t be good")  // prio 4, WARNING in yellow
        log.error("ouch, an error did occur!")  // prio 5, ERROR in red
    }


}

