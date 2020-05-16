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
        var groupService: StubGroupService!
        
        beforeEach {
            authService = StubAuthService()
            userService = StubUserService()
            groupService = StubGroupService()
        }
        
        // 1.
        describe("로그인 화면에서") {
            var reactor: LoginViewReactor!
            var viewController: LoginViewController!
            
            context("로그인 버튼 클릭하면") {
                var signUpReactor: SignUpReactor!
                
                beforeEach {
                    reactor = LoginViewReactor(authService: authService, userService: userService, groupService: groupService)
                    reactor.isStubEnabled = true
                    signUpReactor = SignUpReactor(userService: userService, authService: authService)
                    let signUpFactory = {
                        return SignUpFirstViewController(reactor: signUpReactor) { () -> SignUpSecondViewController in
                            return SignUpSecondViewController(reactor: signUpReactor) { () -> SignUpThirdViewController in
                                return SignUpThirdViewController(reactor: signUpReactor) { () -> SignUpFinishedViewController in
                                    return SignUpFinishedViewController(reactor: signUpReactor,
                                                                        presentMainScreen: { })
                                }
                            }
                        }
                    }
                    
                    viewController = LoginViewController(reactor: reactor,
                                                         presentMainScreen: {},
                                                         findIDViewControllerFactory: {
                                                            return FindIDViewController(reactor: FindIDViewController.Reactor(userService: userService),
                                                                                        findPasswordViewControllerFactory: {
                                                                                            FindPasswordViewController(reactor: FindPasswordViewController.Reactor(userService: userService))
                                                            })
                    },
                                                         findPasswordViewControllerFactory: { return FindPasswordViewController(reactor: FindPasswordViewController.Reactor(userService: userService)) },
                                                         signUpViewControllerFactory: signUpFactory)
                    
                    _ = viewController.view
                }
                
                it("reactor login action 실행") {
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
        
        // 2.
        describe("로그인 화면에서") {
            var reactor: LoginViewReactor!
            var viewController: LoginViewController!
            var presentMainScreen: Bool = false
            var signUpReactor: SignUpReactor!
            
            beforeEach {
                reactor = LoginViewReactor(authService: authService, userService: userService, groupService: groupService)
                reactor.isStubEnabled = true
                signUpReactor = SignUpReactor(userService: userService, authService: authService)
                let signUpFactory = {
                    return SignUpFirstViewController(reactor: signUpReactor) { () -> SignUpSecondViewController in
                        return SignUpSecondViewController(reactor: signUpReactor) { () -> SignUpThirdViewController in
                            return SignUpThirdViewController(reactor: signUpReactor) { () -> SignUpFinishedViewController in
                                return SignUpFinishedViewController(reactor: signUpReactor,
                                                                    presentMainScreen: { })
                            }
                        }
                    }
                }
                
                viewController = LoginViewController(reactor: reactor,
                                                     presentMainScreen: { presentMainScreen = true },
                                                     findIDViewControllerFactory: {
                                                        return FindIDViewController(reactor: FindIDViewController.Reactor(userService: userService),
                                                                                    findPasswordViewControllerFactory: {
                                                                                        FindPasswordViewController(reactor: FindPasswordViewController.Reactor(userService: userService))
                                                        })
                },
                                                     findPasswordViewControllerFactory: { return FindPasswordViewController(reactor: FindPasswordViewController.Reactor(userService: userService)) },
                                                     signUpViewControllerFactory: signUpFactory)
                
                _ = viewController.view
            }
            
            context("로그인이 성공하면") {
                beforeEach {
                    reactor.stub.state.value.isLoggedIn = true
                }
                it("메인 화면으로 이동한다") {
                    expect(presentMainScreen).to(beTrue())
                }
            }
        }
        
        // 3.
        describe("로그인 화면에서") {
            var reactor: LoginViewReactor!
            var viewController: LoginViewController!
            var presentSignupScreen: Bool!
            var signUpReactor: SignUpReactor!
            
            context("회원가입 버튼을 누르면") {
                beforeEach {
                    reactor = LoginViewReactor(authService: authService, userService: userService, groupService: groupService)
                    reactor.isStubEnabled = true
                    signUpReactor = SignUpReactor(userService: userService, authService: authService)
                    
                    let signUpFactory = { () -> SignUpFirstViewController in
                        presentSignupScreen = true
                        let controller = SignUpFirstViewController(reactor: signUpReactor) { () -> SignUpSecondViewController in
                            return SignUpSecondViewController(reactor: signUpReactor) { () -> SignUpThirdViewController in
                                return SignUpThirdViewController(reactor: signUpReactor) { () -> SignUpFinishedViewController in
                                    return SignUpFinishedViewController(reactor: signUpReactor,
                                                                        presentMainScreen: { })
                                }
                            }
                        }
                        return controller
                    }
                    
                    viewController = LoginViewController(reactor: reactor,
                                                         presentMainScreen: { },
                                                         findIDViewControllerFactory: {
                                                            return FindIDViewController(reactor: FindIDViewController.Reactor(userService: userService),
                                                                                        findPasswordViewControllerFactory: {
                                                                                            FindPasswordViewController(reactor: FindPasswordViewController.Reactor(userService: userService))
                                                            })
                    },
                                                         findPasswordViewControllerFactory: { return FindPasswordViewController(reactor: FindPasswordViewController.Reactor(userService: userService)) },
                                                         signUpViewControllerFactory: signUpFactory)
                    
                    _ = viewController.view
                }
                
                it("회원 가입 페이지로 이동한다") {
                    viewController.signUpButton.sendActions(for: .touchUpInside)
                    expect(presentSignupScreen).to(beTrue())
                }
            }
        }
        
        // 4.
        describe("로그인 화면에서") {
            var reactor: LoginViewReactor!
            var viewController: LoginViewController!
            var presentFindIDScreen: Bool!
            var signUpReactor: SignUpReactor!
            
            context("아이디찾기 버튼을 클릭하면") {
                beforeEach {
                    reactor = LoginViewReactor(authService: authService, userService: userService, groupService: groupService)
                    reactor.isStubEnabled = true
                    signUpReactor = SignUpReactor(userService: userService, authService: authService)
                    
                    let signUpFactory = { () -> SignUpFirstViewController in
                        let controller = SignUpFirstViewController(reactor: signUpReactor) { () -> SignUpSecondViewController in
                            return SignUpSecondViewController(reactor: signUpReactor) { () -> SignUpThirdViewController in
                                return SignUpThirdViewController(reactor: signUpReactor) { () -> SignUpFinishedViewController in
                                    return SignUpFinishedViewController(reactor: signUpReactor,
                                                                        presentMainScreen: { })
                                }
                            }
                        }
                        return controller
                    }
                    
                    viewController = LoginViewController(reactor: reactor,
                                                         presentMainScreen: { },
                                                         findIDViewControllerFactory: {
                                                            presentFindIDScreen = true
                                                            return FindIDViewController(reactor: FindIDViewController.Reactor(userService: userService),
                                                                                        findPasswordViewControllerFactory: {
                                                                                            FindPasswordViewController(reactor: FindPasswordViewController.Reactor(userService: userService))
                                                            })
                    },
                                                         findPasswordViewControllerFactory: { return FindPasswordViewController(reactor: FindPasswordViewController.Reactor(userService: userService)) },
                                                         signUpViewControllerFactory: signUpFactory)
                    
                    _ = viewController.view
                }
                
                
                it("아이디 찾기 화면으로 이동한다") {
                    viewController.findIDButton.sendActions(for: .touchUpInside)
                    expect(presentFindIDScreen).to(beTrue())
                }
            }
        }
        
        // 5.
        describe("로그인 화면에서") {
            var reactor: LoginViewReactor!
            var viewController: LoginViewController!
            var presentFindPWScreen: Bool!
            var signUpReactor: SignUpReactor!
            
            context("비밀번호찾기 버튼을 클릭하면") {
                beforeEach {
                    reactor = LoginViewReactor(authService: authService, userService: userService, groupService: groupService)
                    reactor.isStubEnabled = true
                    signUpReactor = SignUpReactor(userService: userService, authService: authService)
                    
                    let signUpFactory = { () -> SignUpFirstViewController in
                        let controller = SignUpFirstViewController(reactor: signUpReactor) { () -> SignUpSecondViewController in
                            return SignUpSecondViewController(reactor: signUpReactor) { () -> SignUpThirdViewController in
                                return SignUpThirdViewController(reactor: signUpReactor) { () -> SignUpFinishedViewController in
                                    return SignUpFinishedViewController(reactor: signUpReactor,
                                                                        presentMainScreen: { })
                                }
                            }
                        }
                        return controller
                    }
                    
                    viewController = LoginViewController(reactor: reactor,
                                                         presentMainScreen: { },
                                                         findIDViewControllerFactory: {
                                                            return FindIDViewController(reactor: FindIDViewController.Reactor(userService: userService),
                                                                                        findPasswordViewControllerFactory: {
                                                                                            FindPasswordViewController(reactor: FindPasswordViewController.Reactor(userService: userService))
                                                            })
                    },
                                                         findPasswordViewControllerFactory: {
                                                            presentFindPWScreen = true
                                                            return FindPasswordViewController(reactor: FindPasswordViewController.Reactor(userService: userService)) },
                                                         signUpViewControllerFactory: signUpFactory)
                    
                    _ = viewController.view
                }
                
                it("비밀번호 찾기 화면으로 이동한다") {
                    viewController.findPWButton.sendActions(for: .touchUpInside)
                    expect(presentFindPWScreen).to(beTrue())
                }
            }
        }
        
    } // spec
}
