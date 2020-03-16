//
//  SplashViewReactorSpec.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/14.
//  
//

import Nimble
import Quick
import Stubber

@testable import TodayMood

class SplashViewReactorSpec: QuickSpec {
    override func spec() {
        var userService: StubUserService!
        var authService: StubAuthService!
        var reactor: SplashViewReactor!
        
        // initialState
        beforeEach {
            authService = StubAuthService()
            userService = StubUserService()
            reactor = SplashViewReactor(userService: userService,
                                        authService: authService)
            _ = reactor.state
        }
        
        //
        describe("initialState") {
            it("isAuthenticated는 최초 nil이어야 한다.") {
                expect(reactor.currentState.isAuthenticated).to(beNil())
            }
        }
        
        //
        describe("state의 isAuthenticated") {
            context("checkAuthenicated 후 API 성공한 경우") {
                it("isAuthenticated은 true이어야 한다.") {
                    Stubber.register(userService.me) { .just(UserFixture.kanz) }
                    reactor.action.onNext(.checkIfAuthenticated)
                    expect(reactor.currentState.isAuthenticated) == true
                }
            }
            
            context("checkAuthenicated 후 API 실패한 경우") {
                it("isAuthenticated은 false이어야 한다.") {
                    Stubber.register(userService.me) { .error(StubError()) }
                    reactor.action.onNext(.checkIfAuthenticated)
                    expect(reactor.currentState.isAuthenticated) == false
                }
            }
        }
        
        context("checkAuthenicated action이 실행되면") {
            it("me api이 호출되어야 한다.") {
                reactor.action.onNext(.checkIfAuthenticated)
                expect(Stubber.executions(userService.me).count) == 1
            }
        }
    }
}
