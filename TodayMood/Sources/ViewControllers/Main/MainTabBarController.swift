//
//  MainTabBarController.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/22.
//

import UIKit

import EMTNeumorphicView
import ReactorKit
import ReusableKit
import RxCocoa
import RxSwift
import RxViewController
import SnapKit
import Then

final class MainTabBarController: UITabBarController, ReactorKit.View {
    
    typealias Reactor = MainTabBarReactor
    
    // MARK: Views
    let tab = MainTabBar().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = false
    }
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    var safeAreaInset: UIEdgeInsets {
        guard let window = UIApplication.shared.windows.first else { return self.view.safeAreaInsets }
        return window.safeAreaInsets
    }
    
    let presentMoodWriteFactory: () -> MoodWriteStatusViewController
    
    init(reactor: MainTabBarReactor,
         homeViewController: HomeViewController,
         groupViewController: GroupViewController,
         statisticsViewController: StatisticsViewController,
         settingsViewController: SettingsViewController,
         presentMoodWriteFactory: @escaping () -> MoodWriteStatusViewController) {
        defer { self.reactor = reactor }
        self.presentMoodWriteFactory = presentMoodWriteFactory
        super.init(nibName: nil, bundle: nil)
        configureTabBar()
        self.viewControllers = [
            BaseNavigationController(rootViewController: homeViewController, navigationBarHidden: true),
            BaseNavigationController(rootViewController: groupViewController),
            BaseNavigationController(rootViewController: statisticsViewController),
            BaseNavigationController(rootViewController: settingsViewController)
        ]
        //            .map { BaseNavigationController(rootViewController: $0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTabBar() {
        self.tabBar.isHidden = false
        
        self.view.addSubview(tab)
        
        tab.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(self.tabBar.frame.height + safeAreaInset.bottom + 5.0)
        }
    }
    
    // MARK: - Binding
    func bind(reactor: Reactor) {
        
        // Action
        self.rx.didSelect
            .scan((nil, nil)) { state, viewController in
                return (state.1, viewController)
        }
            // if select the view controller first time or select the same view controller again
            .filter { state in state.0 == nil || state.0 === state.1 }
            .map { state in state.1 }
            .filterNil()
            .subscribe(onNext: { [weak self] viewController in
                self?.scrollToTop(viewController) // scroll to top
            })
            .disposed(by: self.disposeBag)
        
        tab.rx.selectedIndex
            .subscribe(onNext: { selectedIndex in
                self.selectedIndex = selectedIndex
            }).disposed(by: self.disposeBag)
        
        tab.rx.centerButtonTap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                logger.debug("centerButtonTap")
                self.presentMoodWrite()
            }).disposed(by: self.disposeBag)
        
        // State
        
        // View
    }
    
    func scrollToTop(_ viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController {
            let topViewController = navigationController.topViewController
            let firstViewController = navigationController.viewControllers.first
            if let viewController = topViewController, topViewController === firstViewController {
                self.scrollToTop(viewController)
            }
            return
        }
        guard let scrollView = viewController.view.subviews.first as? UIScrollView else { return }
        scrollView.setContentOffset(.zero, animated: true)
    }
    
    // MARK: Route
    private func presentMoodWrite() {
        let controller = self.presentMoodWriteFactory()
        let nav = controller.navigationWrap(navigationBarHidden: true)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}
