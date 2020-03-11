//
//  CompositionRoot.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/08.
//

import UIKit

import Firebase
import Kingfisher
import KeychainAccess
import RxDataSources
import RxOptional
import RxViewController
import Then
import URLNavigator

import SwiftyBeaver
let logger = SwiftyBeaver.self

struct AppDependency {
    typealias OpenURLHandler = (_ url: URL, _ options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool
    
    let window: UIWindow
    let navigator: Navigator
    let configureSDKs: () -> Void
    let configureAppearance: () -> Void
    let openURL: OpenURLHandler
}

final class CompositionRoot {
    
    static func resolve() -> AppDependency {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        
        // Navigator
        let navigator = Navigator()
        
        let authService = AuthService(navigator: navigator)
        let userNetworking = UserNetworking(plugins: [AuthPlugin(authService: authService)])
        
        // Services
        let userService = UserService(networking: userNetworking)
        
        // URLNavigator
        URLNavigationMap.initialize(navigator: navigator, authService: authService)
        
        var presentMainScreen: (() -> Void)!
        var presentLoginScreen: (() -> Void)!
        
        presentMainScreen = self.configurePresentMainScreen(window: window)
        
        presentLoginScreen = self.configurePresentLoginScreen(window: window,
                                                              presentMainScreen: presentMainScreen)
        
        let reactor = SplashViewReactor(userService: userService,
                                        authService: authService)
        let splashViewController = SplashViewController(
            reactor: reactor,
            presentLoginScreen: presentLoginScreen,
            presentMainScreen: presentMainScreen
        )
        window.rootViewController = splashViewController
        
        return AppDependency(window: window,
                             navigator: navigator,
                             configureSDKs: self.configureSDKs,
                             configureAppearance: self.configureAppearance,
                             openURL: self.openURLFactory(navigator: navigator))
    }
    
    // MARK: Configure SDKs
    static func configureSDKs() {
        // Firebase
        FirebaseApp.configure()
        
        // SwiftyBeaver
        let console = ConsoleDestination()
        console.minLevel = .verbose
        logger.addDestination(console)
    }
    
    // MARK: Configure Appearance
    static func configureAppearance() {
        // NavigationBar Appearance, Toast Appearance..
    }
    
    // MARK: URL Factory
    static func openURLFactory(navigator: NavigatorType) -> AppDependency.OpenURLHandler {
        return { url, options -> Bool in
            if navigator.open(url) {
                return true
            }
            if navigator.present(url, wrap: UINavigationController.self) != nil {
                return true
            }
            return false
        }
    }
    
}

// MARK: - Login
extension CompositionRoot {
    static func configurePresentLoginScreen(window: UIWindow,
                                            presentMainScreen: @escaping () -> Void) -> () -> Void {
        return {
            let reactor = LoginViewReactor()
            window.rootViewController = LoginViewController(reactor: reactor,
                                                            presentMainScreen: presentMainScreen)
        }
    }
}

// MARK: - Main
extension CompositionRoot {
    static func configurePresentMainScreen(window: UIWindow) -> () -> Void {
        return {
            let reactor = MainViewReactor()
            window.rootViewController = MainViewController(reactor: reactor)
        }
    }
}
