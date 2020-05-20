//
//  MoodWriteStatusViewControllerSpec.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/04/21.
//

import Quick
import Nimble

@testable import TodayMood

class MoodWriteStatusViewControllerSpec: QuickSpec {
    override func spec() {
        var moodService: StubMoodService!
        
        beforeEach {
            moodService = StubMoodService()
        }
        
        // 1.
        describe("기분선택 화면에서") {
            var reactor: MoodWriteViewReactor!
            var statusVC: MoodWriteStatusViewController!
            var pushToSummaryScreen: Bool = false
            
            context("현재 기분을 선택하면") {
                beforeEach {
                    reactor = MoodWriteViewReactor(moodService: moodService)
                    // reactor.isStubEnabled = true
                    
                    let pushMoodWriteSummaryViewControllerFactory = { () -> MoodWriteSummaryViewController in
                        pushToSummaryScreen = true
                        return MoodWriteSummaryViewController(reactor: reactor) { (arg) -> MoodWritePublicSettingViewController in
                            let (publicTypes, selectedGroups) = arg
                            let reactor = MoodWritePublicSettingViewReactor(publicType: publicTypes, selectedGroups: selectedGroups)
                            return MoodWritePublicSettingViewController(reactor: reactor) { (selectedGroups) -> MoodWriteGroupListViewController in
                                let reactor = MoodWriteGroupListViewReactor(selectedGroups: selectedGroups)
                                return MoodWriteGroupListViewController(reactor: reactor)
                            }
                        }
                    }
                    
                    statusVC = MoodWriteStatusViewController(reactor: reactor, pushMoodWriteSummaryViewControllerFactory: pushMoodWriteSummaryViewControllerFactory)
                    _ = statusVC.view
                }
                
                it("한줄 메모 페이지로 이동한다.") {
                    statusVC.reactor?.action.onNext(.selectStatus(.good))
                    expect(pushToSummaryScreen).toEventually(beTrue())
                }
            }
        }
        
    } // spec
}

