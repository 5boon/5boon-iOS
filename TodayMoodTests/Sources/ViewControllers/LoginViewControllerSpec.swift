//
//  LoginViewControllerSpec.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/15.
//  
//

import Quick
import Nimble

@testable import TodayMood

class LoginViewControllerSpec: QuickSpec {
    override func spec() {
        var authService: StubAuthService!
        var userService: StubUserService!

        beforeEach {
          authService = StubAuthService()
          userService = StubUserService()
        }

        
        describe("로그인") {
            
            var reactor: LoginViewReactor!
            var viewController: LoginViewController!
            
            context("로그인 버튼 클릭") {
                it("reactor login action 실행") {
                    reactor = LoginViewReactor(authService: authService,
                                                   userService: userService)
                    reactor.isStubEnabled = true
                    viewController = LoginViewController(reactor: reactor,
                                                             presentMainScreen: {},
                                                             signUpViewControllerFactory: {
                                                                let reactor = SignUpViewReactor()
                                                                return SignUpViewController(reactor: reactor)
                    })
                    _ = viewController.view
                    
                    
                    viewController.loginButton.sendActions(for: .touchUpInside)
                    expect(reactor.stub.actions.last).to(match) { (action) -> Bool in
                        if case .login = action {
                            return true
                        } else {
                            return false
                        }
                    }
                }
            }
        }
        
        
        describe("로그인화면") {
            var reactor: LoginViewReactor!
            var viewController: LoginViewController!
            var isPresentMainScreenExecuted: Bool!
            
            beforeEach {
                reactor = LoginViewReactor(authService: authService,
                                           userService: userService)
                reactor.isStubEnabled = true
                isPresentMainScreenExecuted = false
                
                viewController = LoginViewController(reactor: reactor,
                                                     presentMainScreen: { isPresentMainScreenExecuted = true }, signUpViewControllerFactory: {
                                                        let reactor = SignUpViewReactor()
                                                        return SignUpViewController(reactor: reactor)
                })
                _ = viewController.view
            }
            
            context("로그인이 성공하면") {
                beforeEach {
                    reactor.stub.state.value.isLoggedIn = true
                }
                
                it("메인으로 이동한다") {
                    expect(isPresentMainScreenExecuted) == true
                }
            }
            
            context("로그인이 실패하면 ") {
                beforeEach {
                    reactor.stub.state.value.isLoggedIn = false
                }
                
                it("메인으로 이동하지 않는다") {
                    expect(isPresentMainScreenExecuted) == false
                }
            }
        }
    }
}