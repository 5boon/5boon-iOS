//
//  FindIDViewReactorSpec.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/12.
//  
//

import Quick
import Nimble
import Stubber

@testable import TodayMood

class FindIDViewReactorSpec: QuickSpec {
    override func spec() {
        var userService: StubUserService!
        var reactor: FindIDViewReactor!
        
        beforeEach {
            userService = StubUserService()
            reactor = FindIDViewReactor(userService: userService)
            _ = reactor.state
        }
        
        // 1. initialState
        describe("initialState 체크") {
            it("findResult은 nil이어야 한다.") {
                expect(reactor.stub.state.value.findResult).to(beNil())
            }
            
            it("failedText은 nil이어야 한다.") {
                expect(reactor.stub.state.value.failedText).to(beNil())
            }
        }
        
        // 2.
        describe("find 액션 체크") {
            context("find action이 호출되면") {
                it("find api가 호출되어야 한다.") {
                    Stubber.register(userService.findID) { _ in .just(UserFixture.kanz) }
                    reactor.action.onNext(.find("kanz11", "kanz11@5boon.com"))
                    expect(Stubber.executions(userService.findID).count) == 1
                }
            }
        }
        
        // 3.
        describe("find 액션 체크") {
            context("찾는 아이디가 존재하지 않을 경우") {
                it("failedText에 결과 없음 메세지가 셋팅되어야 한다.") {
                    Stubber.register(userService.findID) { _ in .error(StubError()) }
                    reactor.action.onNext(.find("kanz11", "kanz11@5boon.com"))
                    expect(reactor.currentState.failedText).notTo(beNil())
                }
            }
        }
        
        // 4.
        describe("find 액션 체크") {
            context("찾는 아이디가 존재할 경우") {
                it("findResult에 User결과가 셋팅되어야 한다.") {
                    Stubber.register(userService.findID) { _ in .just(UserFixture.kanz) }
                    reactor.action.onNext(.find("kanz11", "kanz11@5boon.com"))
                    expect(reactor.currentState.findResult).notTo(beNil())
                }
            }
        }
        
    } // Spec
}
