//
//  SignUpThirdViewControllerSpec.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/10.
//  
//

import Quick
import Nimble

@testable import TodayMood

class SignUpThirdViewControllerSpec: QuickSpec {
    override func spec() {
        var authService: StubAuthService!
        var userService: StubUserService!
        var reactor: SignUpReactor!
        var viewController: SignUpThirdViewController!
        var executePushToFinish: Bool = false
        
        beforeEach {
            authService = StubAuthService()
            userService = StubUserService()
            reactor = SignUpReactor(userService: userService,
                                    authService: authService)
            reactor.isStubEnabled = true
            viewController = SignUpThirdViewController(reactor: reactor,
                                                       pushFinishedStepScreen: { () -> SignUpFinishedViewController in
                                                        executePushToFinish = true
                                                        return SignUpFinishedViewController(reactor: reactor, presentMainScreen: {})
            })
        }
        
        // 1.
        describe("세번째 스텝에서") {
            context("validation 조건이 성립하지 않으면") {
                it("완료버튼은 활성화 되지 않는다.") {
                    reactor.stub.state.value.isValidateThirdStepField = false
                    expect(viewController.doneButton.isEnabled) == false
                }
            }
        }
        
        // 2.
        describe("세번째 스텝에서") {
            context("완료버튼을 클릭하면") {
                beforeEach {
                    reactor.stub.state.value.id = "KanzTest1"
                    reactor.stub.state.value.password = "111111"
                    reactor.stub.state.value.email = "test@test.com"
                    reactor.stub.state.value.name = "테스트사용자"
                }
                
                it("reactor의 signup이 실행된다.") {
                    viewController.doneButton.sendActions(for: .touchUpInside)
                    expect(reactor.stub.actions.last).to(match) { (action) -> Bool in
                        if case .signUp = action {
                            return true
                        } else {
                            return false
                        }
                    }
                }
            }
        }
        
        // 3.
        describe("세번째 스텝에서") {
            context("가입, 토큰, me 가 완료되면") {
                beforeEach {
                    reactor.stub.state.value.id = "KanzTest1"
                    reactor.stub.state.value.password = "111111"
                    reactor.stub.state.value.email = "test@test.com"
                    reactor.stub.state.value.name = "테스트사용자"
                }
                
                it("최종화면으로 이동한다.") {
                    viewController.doneButton.sendActions(for: .touchUpInside)
                    reactor.stub.state.value.signupFinished = true
                    waitUntil { done in
                        done()
                        expect(executePushToFinish) == true
                    }
                }
            }
        }
        
    } // Spec
}
