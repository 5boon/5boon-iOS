//
//  SplashViewControllerSpec.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/14.
//  
//

import Quick
import Nimble
@testable import TodayMood

class SplashViewControllerSpec: QuickSpec {
    override func spec() {
        
        var authService: StubAuthService!
        var userService: StubUserService!

        beforeEach {
          authService = StubAuthService()
          userService = StubUserService()
        }
        
        //
        describe("스플래시 화면") {
            context("didappear 된 경우") {
                it("checkIfAuthenticated 리액터 액션 호출") {
                    let reactor = SplashViewReactor(userService: userService,
                                                    authService: authService)
                    reactor.isStubEnabled = true
                    let viewController = SplashViewController(reactor: reactor,
                                                              presentLoginScreen: {},
                                                              presentMainScreen: {})
                    _ = viewController.view
                    viewController.viewDidAppear(false)
                    expect(reactor.stub.actions.last).to(equal(.checkIfAuthenticated))
                }
            }
        }
        
        //
        describe("스플래시 화면 화면 이동") {
            var isExecuted: (presentLoginScreen: Bool, presentMainScreen: Bool)!
            var reactor: SplashViewReactor!
            var viewController: SplashViewController!
            
            beforeEach {
                isExecuted = (false, false)
                reactor = SplashViewReactor(userService: userService,
                                            authService: authService)
                reactor.isStubEnabled = true
                viewController = SplashViewController(reactor: reactor,
                                                      presentLoginScreen: { isExecuted.presentLoginScreen = true },
                                                      presentMainScreen: { isExecuted.presentMainScreen = true }
                )
                _ = viewController.view
            }
            
            context("인증이 성공한 경우") {
                beforeEach {
                    // 인증 성공
                    reactor.stub.state.value.isAuthenticated = true
                }
                
                it("로그인 화면은 present되지 않아야 한다") {
                    expect(isExecuted.presentLoginScreen).to(beFalse())
                }
                
                it("메인 화면을 present 한다") {
                    expect(isExecuted.presentMainScreen).to(beTrue())
                }
            }
            
            
            context("인증이 실패한 경우") {
                beforeEach {
                    reactor.stub.state.value.isAuthenticated = false
                }
                
                it("로그인 화면을 present 한다") {
                    expect(isExecuted.presentLoginScreen).to(beTrue())
                }
                
                it("메인 화면은 present되지 않아야 한다") {
                    expect(isExecuted.presentMainScreen).to(beFalse())
                }
            }
        }
    }
}
