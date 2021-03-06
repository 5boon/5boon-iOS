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
import SideMenu
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
        let moodNetworking = MoodNetworking(plugins: [AuthPlugin(authService: authService)])
        let groupNetworking = GroupNetworking(plugins: [AuthPlugin(authService: authService)])
        
        let userService = UserService(networking: userNetworking)
        let moodService = MoodService(networking: moodNetworking)
        let groupService = GroupService(networking: groupNetworking)

        if UserDefaultsConfig.firstLaunch == true {
            authService.logout()
            UserDefaultsConfig.firstLaunch = false
        }
        
        // URLNavigator
        URLNavigationMap.initialize(navigator: navigator, authService: authService)
        
        var presentMainScreen: (() -> Void)!
        var presentLoginScreen: (() -> Void)!
        
        presentMainScreen = {
            let presentMoodWriteFactory = self.configureMoodWriteScreen(moodService: moodService)
            
            let homeVC = self.configureHomeScreen(moodService: moodService)
            let settingVC = self.configureSettingsScreen(authService: authService,
                                                         presentLoginScreen: presentLoginScreen)
            let groupVC = self.configureGroupScreen(groupService: groupService)
            
            let reactor = MainTabBarReactor()
            window.rootViewController = MainTabBarController(reactor: reactor,
                                                             homeViewController: homeVC,
                                                             groupViewController: groupVC,
                                                             statisticsViewController: StatisticsViewController(reactor: StatisticsViewReactor()),
                                                             settingsViewController: settingVC,
                                                             presentMoodWriteFactory: presentMoodWriteFactory)
        }
        
        presentLoginScreen = self.configurePresentLoginScreen(window: window,
                                                              authService: authService,
                                                              userService: userService,
                                                              groupService: groupService,
                                                              presentMainScreen: presentMainScreen)
        
        let reactor = SplashViewReactor(userService: userService,
                                        authService: authService,
                                        groupService: groupService)
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
        /*
         let navigationBarBackgroundImage = UIImage.resizable().color(UIColor.red).image
         UINavigationBar.appearance().setBackgroundImage(navigationBarBackgroundImage, for: .default)
         */
        //        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = UIColor.navigationBackground
        UINavigationBar.appearance().tintColor = UIColor.keyColor
        UINavigationBar.appearance().titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        ]
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
                                            groupService: GroupServiceType,
                                            presentMainScreen: @escaping () -> Void) -> () -> Void {
        return {
            let reactor = LoginViewReactor(authService: authService,
                                           userService: userService,
                                           groupService: groupService)
            
            let findPasswordFactory = self.configureFindPasswordScreen(userService: userService)
            let findIDFactory = self.configureFindIDScreen(userService: userService,
                                                           findPasswordViewControllerFactory: findPasswordFactory)
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
    
    static func configureFindIDScreen(userService: UserServiceType,
                                      findPasswordViewControllerFactory: @escaping () -> FindPasswordViewController) -> () -> FindIDViewController {
        return {
            let reactor = FindIDViewReactor(userService: userService)
            return FindIDViewController(reactor: reactor,
                                        findPasswordViewControllerFactory: findPasswordViewControllerFactory)
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
    static func configureHomeScreen(moodService: MoodServiceType) -> HomeViewController {
        let reactor = HomeViewReactor(moodService: moodService)
        return HomeViewController(reactor: reactor)
    }
    
    static func configureMoodWriteScreen(moodService: MoodServiceType) -> () -> MoodWriteStatusViewController {
        return {
            
            let reactor = MoodWriteViewReactor(moodService: moodService)
            
            var pushSummaryScreen: (() -> MoodWriteSummaryViewController)!
            var presentPublicSettingScreen: ((MoodPublicSettingTypes, [PublicGroup]) -> MoodWritePublicSettingViewController)!
            
            presentPublicSettingScreen = { (publicType, selectedGroup) -> MoodWritePublicSettingViewController in
                let reactor = MoodWritePublicSettingViewReactor(publicType: publicType, selectedGroups: selectedGroup)
                return MoodWritePublicSettingViewController(reactor: reactor,
                                                            pushMoodWriteGroupListViewControllerFactory: { selectedGroups -> MoodWriteGroupListViewController in
                                                                let reactor = MoodWriteGroupListViewReactor(selectedGroups: selectedGroups)
                                                                return MoodWriteGroupListViewController(reactor: reactor)
                })
            }
            
            let summaryViewController = MoodWriteSummaryViewController(reactor: reactor,
                                                                       presentMoodWritePublicSettingViewControllerFactory: presentPublicSettingScreen)
            
            pushSummaryScreen = {
                return summaryViewController
            }
            
            return MoodWriteStatusViewController(reactor: reactor,
                                                 pushMoodWriteSummaryViewControllerFactory: pushSummaryScreen)
        }
    }

    static func configureSettingsScreen(authService: AuthServiceType,
                                        presentLoginScreen: @escaping () -> Void) -> SettingsViewController {
        let reactor = SettingsViewReactor(authService: authService)
        return SettingsViewController(reactor: reactor, presentLoginScreen: presentLoginScreen)
    }
}

// MARK: - Group
extension CompositionRoot {
    static func configureGroupScreen(groupService: GroupServiceType) -> GroupViewController {
        var presentAddGroupScreen: (() -> GroupAddViewController)!
        var pushGroupDetailFactory: ((PublicGroup) -> GroupDetailViewController)!
        
        presentAddGroupScreen = {
            GroupAddViewController(reactor: GroupAddViewReactor(groupService: groupService))
        }
        
        pushGroupDetailFactory = { (groupInfo) -> GroupDetailViewController in
            let reactor = GroupDetailViewReactor(groupService: groupService, groupInfo: groupInfo)
            return GroupDetailViewController(reactor: reactor)
        }
        
        let reactor = GroupViewReactor(groupService: groupService)
        return GroupViewController(reactor: reactor,
                                   presentAddGroupFactory: presentAddGroupScreen,
                                   pushGroupDetailFactory: pushGroupDetailFactory)
    }
}
