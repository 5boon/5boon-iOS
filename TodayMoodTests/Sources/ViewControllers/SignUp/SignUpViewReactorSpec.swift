//
//  SignUpViewReactorSpec.swift
//  TodayMood
//
//  Created by Kanz on 2020/04/10.
//  
//

import Quick
import Nimble
import Stubber

@testable import TodayMood

class SignUpViewReactorSpec: QuickSpec {
    override func spec() {
        var userService: StubUserService!
        var authService: StubAuthService!
        var reactor: SignUpReactor!
        
        beforeEach {
            userService = StubUserService()
            authService = StubAuthService()
            reactor = SignUpReactor(userService: userService,
                                    authService: authService)
            _ = reactor.state
        }
        
        // 1.
        describe("initialState 체크") {
            context("기본 validataion은 false여야 한다.") {
                it("isValidateFirstStep == false") {
                    expect(reactor.stub.state.value.isValidateFirstStepField) == false
                }
                
                it("isValidateSecondStep == false") {
                    expect(reactor.stub.state.value.isValidateSecondStepField) == false
                }
                
                it("isValidateThirdStep == false") {
                    expect(reactor.stub.state.value.isValidateThirdStepField) == false
                }
            }
        }
        
        // 2.
        describe("first step 체크") {
            context("다음버튼 클릭시, ID중복 체크 action이 호출되고") {
                it("checkDuplicateID가 실행된다.") {
                    Stubber.register(userService.checkDuplicateID) { _ in .just(Void()) }
                    reactor.stub.state.value.id = "kanz11"
                    reactor.action.onNext(.checkDuplicateID)
                    expect(Stubber.executions(userService.checkDuplicateID).count) == 1
                }
            }
            
            context("checkDuplicateID를 통해 유저 결과가 있는 경우") {
                it("isDuplicateID는 true가 된다.") {
                    Stubber.register(userService.checkDuplicateID) { _ in .just(Void()) }
                    reactor.stub.state.value.id = "kanz11"
                    reactor.action.onNext(.checkDuplicateID)
                    expect(reactor.currentState.isDuplicateID) == true
                }
            }
            
            context("checkDuplicateID를 통해 유저 결과가 없는 경우") {
                it("isDuplicateID는 true가 된다.") {
                    Stubber.register(userService.checkDuplicateID) { _ in .error(StubError()) }
                    reactor.stub.state.value.id = "kanz11"
                    reactor.action.onNext(.checkDuplicateID)
                    expect(reactor.currentState.isDuplicateID) == false
                }
            }
            
            context("Validation check") {
                it("두 필드의 조건을 만족하면 isValidateFirstStepField는 true가 된다.") {
                    reactor.action.onNext(.setID("kanz11"))
                    reactor.action.onNext(.setPassword("111111"))
                    expect(reactor.currentState.isValidateFirstStepField) == true
                }
            }
        }
        
        // 3.
        describe("second step 체크") {
            context("다음버튼 클릭시, email중복 체크 action이 호출되고") {
                it("checkDuplicateID가 실행된다.") {
                    Stubber.register(userService.checkDuplicateID) { _ in .just(Void()) }
                    reactor.stub.state.value.email = "test@test.com"
                    reactor.action.onNext(.checkDuplicateEmail)
                    expect(Stubber.executions(userService.checkDuplicateID).count) == 1
                }
            }
            
            context("checkDuplicateID를 통해 유저 결과가 있는 경우") {
                it("isDuplicateID는 true가 된다.") {
                    Stubber.register(userService.checkDuplicateID) { _ in .just(Void()) }
                    reactor.stub.state.value.email = "test@test.com"
                    reactor.action.onNext(.checkDuplicateEmail)
                    expect(reactor.currentState.isDuplicatedEmail) == true
                }
            }
            
            context("checkDuplicateID를 통해 유저 결과가 없는 경우") {
                it("isDuplicateID는 true가 된다.") {
                    Stubber.register(userService.checkDuplicateID) { _ in .error(StubError()) }
                    reactor.stub.state.value.email = "test@test.com"
                    reactor.action.onNext(.checkDuplicateEmail)
                    expect(reactor.currentState.isDuplicatedEmail) == false
                }
            }
            
            context("Validation check") {
                it("필드의 조건을 만족하면 isValidateSecondStepField는 true가 된다.") {
                    reactor.action.onNext(.setEmail("test@test.com"))
                    expect(reactor.currentState.isValidateSecondStepField) == true
                }
            }
        }
        
        // 4.
        describe("third step 체크") {
            context("Validation check") {
                it("필드의 조건을 만족하면 isValidateThirdStepField는 true가 된다.") {
                    reactor.action.onNext(.setName("테스트이름"))
                    expect(reactor.currentState.isValidateThirdStepField) == true
                }
            }
            
            context("완료 버튼 클릭하면 signup action 호출") {
                it("signup_token_me api 순으로 호출한다.") {
                    
                    reactor.stub.state.value.id = "KanzTest1"
                    reactor.stub.state.value.password = "111111"
                    reactor.stub.state.value.email = "test@test.com"
                    reactor.stub.state.value.name = "테스트사용자"
                    
                    var identifiers: [String] = []
                    Stubber.register(userService.signup) { _ in
                        identifiers.append("signup")
                        return .just(UserFixture.kanz)
                    }
                    Stubber.register(authService.requestToken) { (username, password) in
                        identifiers.append("requestToken")
                        return .just(())
                    }
                    Stubber.register(userService.me) {
                        identifiers.append("me")
                        return .just(UserFixture.kanz)
                    }
                    
                    reactor.action.onNext(.signUp)
                    expect(Stubber.executions(userService.signup).count) == 1
                    expect(Stubber.executions(authService.requestToken).count) == 1
                    expect(Stubber.executions(userService.me).count) == 1
                    expect(identifiers) == ["signup", "requestToken", "me"]
                }
            }
        }
        
    } // Spec
}
