//
//  main.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/08.
//

import UIKit

private func appDelegateClassName() -> String {
    let isTesting = NSClassFromString("XCTestCase") != nil
    return isTesting ? "TodayMoodTests.StubAppDelegate" : NSStringFromClass(AppDelegate.self)
}

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    NSStringFromClass(UIApplication.self),
    appDelegateClassName()
)
