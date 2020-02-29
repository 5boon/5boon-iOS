//
//  AppDelegate.swift
//  TodayMood
//
//  Created by Kanz on 2020/02/25.
//  Copyright © 2020 5boon. All rights reserved.
//

import UIKit
import Firebase

import SwiftyBeaver
let logger = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureSDKs()
        
        let vc = ViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: Configure SDKs
    private func configureSDKs() {
        let console = ConsoleDestination()
        console.minLevel = .verbose
        logger.addDestination(console)
        FirebaseApp.configure() 
    }
}

