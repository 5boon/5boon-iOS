//
//  TestConfiguration.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/14.
//  
//

import Quick
import Stubber

@testable import TodayMood

class TestConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        configuration.beforeEach {
            Stubber.clear()
            UIApplication.shared.delegate = StubAppDelegate()
        }
        
        configuration.afterEach {
            Stubber.clear()
        }
    }
}
