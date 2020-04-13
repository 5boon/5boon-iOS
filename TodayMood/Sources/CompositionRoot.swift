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
        FirebaseApp.configure()
        
        // SwiftyBeaver
        let console = ConsoleDestination()
        console.minLevel = .verbose
        logger.addDestination(console)
        
        #if DEBUG
        // Bagel
        Bagel.start()
        #endif
    }
    
    // MARK: Configure Appearance
    static func configureAppearance() {
        // NavigationBar Appearance, Toast Appearance..
        //        let navigationBarBackgroundImage = UIImage.resizable().color(.db_charcoal).image
        //        UINavigationBar.appearance().setBackgroundImage(navigationBarBackgroundImage, for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        //        UINavigationBar.appearance().barStyle = .black
        //        UINavigationBar.appearance().tintColor = .db_slate
        //        UITabBar.appearance().tintColor = .db_charcoal
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
            
            let findIDFactory = self.configureFindIDScreen(userService: userService)
            let findPasswordFactory = self.configureFindPasswordScreen(userService: userService)
            let signUpViewControllerFactory = self.configureSignUpScreen(userService: userService,
                                                                         authService: authService,
                                                              presentMainScreen: presentMainScreen)
            
            let loginViewController = LoginViewController(reactor: reactor,
                                                          presentMainScreen: presentMainScreen,
                                                          findIDViewControllerFactory: findIDFactory,
                                                          findPasswordViewControllerFactory: findPasswordFactory,
                                                          signUpViewControllerFactory: signUpViewControllerFactory)
            
            window.rootViewController = loginViewController.navigationWrap(navigationBarHidden: true)
        }
    }
    
    static func configureSignUpScreen(userService: UserServiceType,
                                      authService: AuthServiceType,
                                      presentMainScreen: @escaping () -> Void) -> () -> SignUpFirstViewController {
        return {
            var pushSecondStepScreen: (() -> SignUpSecondViewController)!
            var pushThirdStepScreen: (() -> SignUpThirdViewController)!
            var pushFinishStepScreen: (() -> SignUpFinishedViewController)!
            
            let reactor = SignUpReactor(userService: userService,
                                        authService: authService)
            
            pushFinishStepScreen = {
                SignUpFinishedViewController(reactor: reactor,
                                             presentMainScreen: presentMainScreen)
            }
            
            pushThirdStepScreen = {
                SignUpThirdViewController(reactor: reactor,
                                          pushFinishedStepScreen: pushFinishStepScreen)
            }
            
            pushSecondStepScreen = {
                SignUpSecondViewController(reactor: reactor, pushThirdStepScreen: pushThirdStepScreen)
            }
            
            let signUpFirstVC = SignUpFirstViewController(reactor: reactor,
                                                          pushSecondStepScreen: pushSecondStepScreen)
            
            return signUpFirstVC
        }
    }
    
    static func configureFindIDScreen(userService: UserServiceType) -> () -> FindIDViewController {
        return {
            let reactor = FindIDViewReactor(userService: userService)
            return FindIDViewController(reactor: reactor)
        }
    }
    
    static func configureFindPasswordScreen(userService: UserServiceType) -> () -> FindPasswordViewController {
        return {
            let reactor = FindPasswordViewReactor(userService: userService)
            return FindPasswordViewController(reactor: reactor)
        }
    }
}

// MARK: - Main
extension CompositionRoot {
    static func configurePresentMainScreen(window: UIWindow) -> () -> Void {
        return {
            let reactor = MainTabBarReactor()
            window.rootViewController = MainTabBarController(reactor: reactor,
                                                             homeViewController: HomeViewController(reactor: HomeViewReactor()),
                                                             groupViewController: GroupViewController(reactor: GroupViewReactor()),
                                                             statisticsViewController: StatisticsViewController(reactor: StatisticsViewReactor()),
                                                             settingsViewController: SettingsViewController(reactor: SettingsViewReactor()))
        }
    }
}
