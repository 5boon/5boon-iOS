//
//  AppDelegate.swift
//  TodayMood
//
//  Created by Kanz on 2020/02/25.
//  Copyright © 2020 5boon. All rights reserved.
//

import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var dependency: AppDependency!
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.dependency = self.dependency ?? CompositionRoot.resolve()
        self.dependency.configureSDKs()
        self.dependency.configureAppearance()
        self.window = self.dependency.window
        return true
    }
}
