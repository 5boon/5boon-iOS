//
//  MainTabBarControllerSpec.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/16.
//  
//

import Quick
import Nimble

@testable import TodayMood

class MainTabBarControllerSpec: QuickSpec {
    override func spec() {

        var reactor: MainTabBarReactor!
        
        var homeVC: HomeViewController!
        var groupVC: GroupViewController!
        var statisticsVC: StatisticsViewController!
        var settingVC: SettingsViewController!
        var presentMoodWriteFactory: (() -> MoodWriteStatusViewController)!
        var viewController: MainTabBarController!
        
        describe("탭바 화면에서") {
            var presentWriteScreen: Bool = false
            context("TabBar의 작성버튼을 클릭하면") {
                beforeEach {
                    reactor = MainTabBarReactor()
                    reactor.isStubEnabled = true
                    
                    homeVC = self.homeVC()
                    groupVC = self.groupVC()
                    statisticsVC = self.statisticsVC()
                    settingVC = self.settingVC()
                    presentMoodWriteFactory = {
                        presentWriteScreen = true
                        return self.moodWriteVC()
                    }
                    
                    viewController = MainTabBarController(reactor: reactor,
                                                          homeViewController: homeVC,
                                                          groupViewController: groupVC,
                                                          statisticsViewController: statisticsVC,
                                                          settingsViewController: settingVC,
                                                          presentMoodWriteFactory: presentMoodWriteFactory)
                }
                
                it("MoodWrite 컨트롤러가 present 된다") {
                    viewController.tab.centerButton.sendActions(for: .touchUpInside)
                    expect(presentWriteScreen).to(beTrue())
                }
            }
        }
    }
    
    func homeVC() -> HomeViewController {
        let reactor = HomeViewReactor()
        return HomeViewController(reactor: reactor)
    }
    
    func groupVC() -> GroupViewController {
        let reactor = GroupViewReactor()
        return GroupViewController(reactor: reactor)
    }
    
    func statisticsVC() -> StatisticsViewController {
        let reactor = StatisticsViewReactor()
        return StatisticsViewController(reactor: reactor)
    }
    
    func settingVC() -> SettingsViewController {
        let reactor = SettingsViewReactor()
        return SettingsViewController(reactor: reactor)
    }
    
    func moodWriteVC() -> MoodWriteStatusViewController {
        let moodService = StubMoodService()
        let reactor = MoodWriteViewReactor(moodService: moodService)
        return MoodWriteStatusViewController(reactor: reactor) { () -> MoodWriteSummaryViewController in
            return MoodWriteSummaryViewController(reactor: reactor) { (arg) -> MoodWritePublicSettingViewController in
                let (publicTypes, selectedGroups) = arg
                let reactor = MoodWritePublicSettingViewReactor(publicType: publicTypes, selectedGroups: selectedGroups)
                return MoodWritePublicSettingViewController(reactor: reactor) { selectedGroups -> MoodWriteGroupListViewController in
                    let reactor = MoodWriteGroupListViewReactor(selectedGroups: selectedGroups)
                    return MoodWriteGroupListViewController(reactor: reactor)
                }
            }
        }
    }
}
