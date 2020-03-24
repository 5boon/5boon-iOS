//
//  CompositionRoot.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/08.
//

import UIKit

import Bagel
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
        
        let authNetworking = AuthNetworking()
        let authService = AuthService(navigator: navigator, networking: authNetworking)
        let userNetworking = UserNetworking(plugins: [AuthPlugin(authService: authService)])
        
        let userService = UserService(networking: userNetworking)
        
        if UserDefaultsConfig.firstLaunch == true {
            authService.logout()
            UserDefaultsConfig.firstLaunch = false
        }
        
        // URLNavigator
        URLNavigationMap.initialize(navigator: navigator, authService: authService)
        
        var presentMainScreen: (() -> Void)!
        var presentLoginScreen: (() -> Void)!
        
        presentMainScreen = self.configurePresentMainScreen(window: window)
        
        presentLoginScreen = self.configurePresentLoginScreen(window: window,
                                                              authService: authService,
                                                              userService: userService,
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
        // FirebaseApp.configure()
        
        // SwiftyBeaver
        let console = ConsoleDestination()
        console.minLevel = .verbose
        logger.addDestination(console)
        
        #if DEBUG
        Bagel.start()
        #endif
    }
    
    // MARK: Configure Appearance
    static func configureAppearance() {
        // NavigationBar Appearance, Toast Appearance..
        UINavigationBar.appearance().shadowImage = UIImage()
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
                                            authService: AuthServiceType,
                                            userService: UserServiceType,
                                            presentMainScreen: @escaping () -> Void) -> () -> Void {
        return {
            let reactor = LoginViewReactor(authService: authService,
                                           userService: userService)
            
            let nickNameViewControllerFactory = { (email: String, password: String) -> NickNameViewController in
                let reactor = NickNameViewReactor(userService: userService,
                                                  authService: authService,
                                                  email: email,
                                                  password: password)
                return NickNameViewController(reactor: reactor,
                                              presentMainScreen: presentMainScreen)
            }
            
            let signUpViewControllerFactory = { () -> SignUpViewController in
                let reactor = SignUpViewReactor()
                return SignUpViewController(reactor: reactor,
                                            nickNameViewControllerFactory: nickNameViewControllerFactory)
            }
            
            let loginViewController = LoginViewController(reactor: reactor,
                                                          presentMainScreen: presentMainScreen,
                                                          signUpViewControllerFactory: signUpViewControllerFactory)
            
            window.rootViewController = loginViewController.navigationWrap()
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
