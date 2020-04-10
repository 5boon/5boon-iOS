//
//  LoginViewReactorSpec.swift
//  TodayMood
//
//  Created by Kanz on 2020/03/15.
//  
//

import Quick
import Nimble
import Stubber

@testable import TodayMood

class LoginViewReactorSpec: QuickSpec {
    override func spec() {
        var userService: StubUserService!
        var authService: StubAuthService!
        var reactor: LoginViewReactor!
        
        beforeEach {
            authService = StubAuthService()
            userService = StubUserService()
            reactor = LoginViewReactor(authService: authService,
                                       userService: userService)
            _ = reactor.state
        }
        
        // 1.
        describe("initialState") {
            it("isLoggedIn 초기값은 false여야 한다.") {
                expect(reactor.currentState.isLoggedIn) == false
            }
        }
        
        // 2.
        describe("로그인 화면에서") {
            context("로그인 버튼을 클릭하면") {
                it("토큰 api 호출 후, me api를 호출한다.") {
                    var identifiers: [String] = []
                    Stubber.register(authService.requestToken) { (username, password) in
                        identifiers.append("requestToken")
                        return .just(())
                    }
                    
                    Stubber.register(userService.me) {
                        identifiers.append("me")
                        return .just(UserFixture.kanz)
                    }
                    reactor.action.onNext(.login(userName: "kanz", password: "111111"))
                    expect(Stubber.executions(authService.requestToken).count) == 1
                    expect(Stubber.executions(userService.me).count) == 1
                    expect(identifiers) == ["requestToken", "me"]
                }
            }
        }
        
    } // Spec
}
