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
        var groupService: StubGroupService!
        
        var reactor: SplashViewReactor!
        
        // initialState
        beforeEach {
            authService = StubAuthService()
            userService = StubUserService()
            groupService = StubGroupService()
            
            reactor = SplashViewReactor(userService: userService,
                                        authService: authService,
                                        groupService: groupService)
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
            context("checkAuthenicated 후 API 두가지 호출을 성공한 경우") {
                it("isAuthenticated은 true이어야 한다.") {
                    Stubber.register(userService.me) { .just(UserFixture.kanz) }
                    Stubber.register(groupService.groupList) { .just([GroupFixture.kanzGroup1, GroupFixture.kanzGroup2]) }
                    reactor.action.onNext(.checkIfAuthenticated)
                    expect(reactor.currentState.isAuthenticated) == true
//                    expect(Stubber.executions(groupService.groupList).count) == 1
                }
            }
            
            context("checkAuthenicated 후 API 두가지 호출이 실패한 경우") {
                it("isAuthenticated은 false이어야 한다.") {
                    Stubber.register(userService.me) { .error(StubError()) }
                    Stubber.register(groupService.groupList) { .error(StubError()) }
                    reactor.action.onNext(.checkIfAuthenticated)
                    expect(reactor.currentState.isAuthenticated) == false
                }
            }
        }
        
        context("checkAuthenicated action이 실행되면") {

            it("me api -> groupList api 순으로 호출되어야 한다.") {
                var identifiers: [String] = []
                
                Stubber.register(userService.me) {
                    identifiers.append("me")
                    return .just(UserFixture.kanz)
                }
                
                Stubber.register(groupService.groupList) {
                    identifiers.append("groupList")
                    return .just([GroupFixture.kanzGroup1, GroupFixture.kanzGroup2])
                }
                
                reactor.action.onNext(.checkIfAuthenticated)
                expect(Stubber.executions(userService.me).count) == 1
                expect(Stubber.executions(groupService.groupList).count) == 1
                expect(identifiers) == ["me", "groupList"]
            }
        }
    }
}
