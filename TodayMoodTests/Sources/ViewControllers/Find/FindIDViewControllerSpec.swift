//
//  FindIDViewControllerSpec.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/12.
//  
//

import Quick
import Nimble

@testable import TodayMood

class FindIDViewControllerSpec: QuickSpec {
    override func spec() {
        var userService: StubUserService!
        
        // 1.
        describe("아이디 찾기 화면에서") {
            beforeEach {
                userService = StubUserService()
            }
            
            var reactor: FindIDViewReactor!
            var viewController: FindIDViewController!
            
            context("확인버튼을 누르면") {
                beforeEach {
                    reactor = FindIDViewReactor(userService: userService)
                    reactor.isStubEnabled = true
                    viewController = FindIDViewController(reactor: reactor,
                                                          findPasswordViewControllerFactory: {
                                                            FindPasswordViewController(reactor: FindPasswordViewController.Reactor(userService: userService))
                    })
                    _ = viewController.view
                }
                
                it("reactor의 Find action이 실행된다.") {
                    viewController.doneButton.sendActions(for: .touchUpInside)
                    expect(reactor.stub.actions.last).to(match) { (action) -> Bool in
                        if case .find = action {
                            return true
                        } else {
                            return false
                        }
                    }
                }
            }
        }
        
        // 2.
        describe("아이디 찾기 화면에서") {
            beforeEach {
                userService = StubUserService()
            }
            
            var reactor: FindIDViewReactor!
            var viewController: FindIDViewController!
            
            context("찾는 결과가 있을 경우") {
                beforeEach {
                    reactor = FindIDViewReactor(userService: userService)
                    reactor.isStubEnabled = true
                    viewController = FindIDViewController(reactor: reactor,
                                                          findPasswordViewControllerFactory: {
                                                            FindPasswordViewController(reactor: FindPasswordViewController.Reactor(userService: userService))
                    })
                    _ = viewController.view
                    
                    reactor.stub.state.value.findResult = UserFixture.kanz
                }
                
                it("회원 아이디 ResultView가 보여져야 한다.") {
                    expect(viewController.resultBackView.isHidden).to(beFalse())
                }
            }
        }
        
        // 3.
        describe("아이디 찾기 화면에서") {
            beforeEach {
                userService = StubUserService()
            }
            
            var reactor: FindIDViewReactor!
            var viewController: FindIDViewController!
            
            context("해당 사용자가 없는 것으로 조회될 경우") {
                beforeEach {
                    reactor = FindIDViewReactor(userService: userService)
                    reactor.isStubEnabled = true
                    viewController = FindIDViewController(reactor: reactor,
                                                          findPasswordViewControllerFactory: {
                                                            FindPasswordViewController(reactor: FindPasswordViewController.Reactor(userService: userService))
                    })
                    _ = viewController.view
                    
                    reactor.stub.state.value.failedText = "해당 ID를 사용하는 사용자가 없습니다."
                }
                
                it("notFoundLabel이 보여져야 한다.") {
                    expect(viewController.notFoundLabel.isHidden).to(beFalse())
                }
            }
        }
        
    } // Spec
}
