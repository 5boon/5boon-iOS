//
//  SignUpSecondViewControllerSpec.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/10.
//  
//

import Quick
import Nimble

@testable import TodayMood

class SignUpSecondViewControllerSpec: QuickSpec {
    override func spec() {
        var authService: StubAuthService!
        var userService: StubUserService!
        var reactor: SignUpReactor!
        var viewController: SignUpSecondViewController!
        var executePushToThird: Bool = false
        
        beforeEach {
          authService = StubAuthService()
          userService = StubUserService()
            reactor = SignUpReactor(userService: userService, authService: authService)
            reactor.isStubEnabled = true
            viewController = SignUpSecondViewController(reactor: reactor) { () -> SignUpThirdViewController in
                executePushToThird = true
                return SignUpThirdViewController(reactor: reactor) { () -> SignUpFinishedViewController in
                    return SignUpFinishedViewController(reactor: reactor, presentMainScreen: {})
                }
            }
            _ = viewController.view
        }
        
        // 1.
        describe("두번째 스텝에서") {
            context("validation 조건이 성립하지 않으면") {
                it("다음버튼은 활성화 되지 않는다.") {
                    reactor.stub.state.value.isValidateSecondStepField = false
                    expect(viewController.nextButton.isEnabled) == false
                }
            }
        }
        
        // 2.
        describe("두번째 스텝에서") {
            context("다음버튼을 클릭하면") {
                it("reactor의 checkDuplicate email이 실행된다.") {
                    viewController.nextButton.sendActions(for: .touchUpInside)
                    expect(reactor.stub.actions.last).to(match) { (action) -> Bool in
                        if case .checkDuplicateEmail = action {
                            return true
                        } else {
                            return false
                        }
                    }
                }
            }
        }
        
        // 3.
        describe("두번째 스텝에서") {
            context("해당 Email이 이미 존재하는 경우") {
                it("중복된 이메일 표시가 노출된다") {
                    reactor.stub.state.value.isDuplicatedEmail = true
                    expect(viewController.duplicateLabel.isHidden) == false
                }
            }
        }
        
        // 4.
        describe("두번째 스텝에서") {
            context("중복체크가 완료되면") {
                it("세번째 화면으로 이동한다.") {
                    reactor.stub.state.value.isDuplicatedEmail = false
                    expect(executePushToThird) == true
                }
            }
        }
        
    } // Spec
}
