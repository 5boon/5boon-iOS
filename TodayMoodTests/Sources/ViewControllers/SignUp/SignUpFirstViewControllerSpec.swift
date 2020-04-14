//
//  SignUpFirstViewControllerSpec.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/10.
//  
//

import Quick
import Nimble

@testable import TodayMood

class SignUpFirstViewControllerSpec: QuickSpec {
    override func spec() {
        var authService: StubAuthService!
        var userService: StubUserService!
        var reactor: SignUpReactor!
        var viewController: SignUpFirstViewController!
        var executePushToSecond: Bool = false
        
        beforeEach {
          authService = StubAuthService()
          userService = StubUserService()
            reactor = SignUpReactor(userService: userService, authService: authService)
            reactor.isStubEnabled = true
            viewController = SignUpFirstViewController(reactor: reactor, pushSecondStepScreen: { () -> SignUpSecondViewController in
                executePushToSecond = true
                return SignUpSecondViewController(reactor: reactor) { () -> SignUpThirdViewController in
                    return SignUpThirdViewController(reactor: reactor) { () -> SignUpFinishedViewController in
                        return SignUpFinishedViewController(reactor: reactor, presentMainScreen: {})
                    }
                }
            })
            _ = viewController.view
        }
        
        // 1.
        describe("첫번째 스텝에서") {
            context("validation 조건이 성립하지 않으면") {
                it("다음버튼은 활성화 되지 않는다.") {
                    reactor.stub.state.value.isValidateFirstStepField = false
                    expect(viewController.nextButton.isEnabled) == false
                }
            }
        }
        
        // 2.
        describe("첫번째 스텝에서") {
            context("다음버튼을 클릭하면") {
                it("reactor의 checkDuplicate id가 실행된다.") {
                    viewController.nextButton.sendActions(for: .touchUpInside)
                    expect(reactor.stub.actions.last).to(match) { (action) -> Bool in
                        if case .checkDuplicateID = action {
                            return true
                        } else {
                            return false
                        }
                    }
                }
            }
        }
        
        // 3.
        describe("첫번째 스텝에서") {
            context("해당 아이디가 이미 존재하는 경우") {
                it("중복된 아이디 표시가 노출된다") {
                    reactor.stub.state.value.isDuplicateID = true
                    waitUntil { done in
                        done()
                        expect(viewController.duplicateLabel.isHidden) == false
                    }
                }
            }
        }
        
        // 4.
        describe("첫번째 스텝에서") {
            context("중복체크가 완료되면") {
                it("두번째 화면으로 이동한다.") {
                    reactor.stub.state.value.isDuplicateID = false
                    waitUntil { done in
                        done()
                        expect(executePushToSecond) == true
                    }
                }
            }
        }
        
    } // Spec
}
