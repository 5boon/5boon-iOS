//
//  MoodWriteSummaryViewControllerSpec.swift
//  TodayMoodTests
//
//  Created by Kanz on 2020/04/21.
//

import Foundation

import Quick
import Nimble
import RxBlocking

@testable import TodayMood

class MoodWriteSummaryViewControllerSpec: QuickSpec {
    override func spec() {
        var moodService: StubMoodService!
        
        beforeEach {
            moodService = StubMoodService()
        }
        
        // 1.
        describe("한줄쓰기 화면에서") {
            var reactor: MoodWriteViewReactor!
            var summaryVC: MoodWriteSummaryViewController!
            var presentPublicSettingScreen: Bool = false
            var tapGR: UITapGestureRecognizer!
            
            context("공개 설정 버튼을 클릭하면") {
                beforeEach {
                    reactor = MoodWriteViewReactor(moodService: moodService)

                    summaryVC = MoodWriteSummaryViewController(reactor: reactor, presentMoodWritePublicSettingViewControllerFactory: { (arg) -> MoodWritePublicSettingViewController in
                        presentPublicSettingScreen = true
                        let (publicTypes, selectedGroups) = arg
                        let reactor = MoodWritePublicSettingViewReactor(publicType: publicTypes, selectedGroups: selectedGroups)
                        return MoodWritePublicSettingViewController(reactor: reactor) { (selectedGroups) -> MoodWriteGroupListViewController in
                            let reactor = MoodWriteGroupListViewReactor(selectedGroups: selectedGroups)
                            return MoodWriteGroupListViewController(reactor: reactor)
                        }
                    })
                    _ = summaryVC.view
                    
                    tapGR = summaryVC.publicSettingView.gestureRecognizers?.first(where: { $0 is UITapGestureRecognizer }) as! UITapGestureRecognizer
                }
                
                it("공개 범위 설정화면으로 이동한다(modal)") {

                }
            }
        }
        
        // 2.
        describe("한줄쓰기 화면에서") {
            context("완료 버튼을 클릭하면") {
                it("sendCreateMood action이 실행된다.") {
                    
                }
            }
        }
        
        // 3.
        describe("한줄쓰기 화면에서") {
            context("작성이 완료되면") {
                it("화면을 dismiss 시킨다") {
                    
                }
            }
        }
        
    } // spec
}
